# overwrite initial html doc and table header into file 
echo "<!DOCTYPE html>
<html>
	<body>
		<table>
			<tr><th>Year Released</th><th>Average Amount</th></tr>
" > ba3.html

# export title|year_released|gross
cut -f 1,3,4 -d ',' biopics_v2.csv --output-delimiter='|' | 
# remove headers
tail -n +2 |
# remove $ signs (for gross cleanup) 
tr -d '$' | 
# remove gross with '-'
sed '/|-/d' |
# get unique values 
uniq |
# iterate over lines and add [gross] to [title] key value store
# add count to [title] key value store
# print in format [country] [grossTotal/count] 
awk -F'|' '
{
	a[$2]+=$3;
	b[$2]++
}
END {
	for (i in a)
		if (a[i] > 0) 
			print i,int(a[i]/b[i])
}' | 
# sort and write over file
sort |
sed 's/ /<\/td><td>$/g' | 
sed 's/^/<tr><td>/g' | 
sed 's/$/<\/td><\/tr>/g' >> ba3.html

# append end html closing tags
echo "
		</table>
	</body>
</html>" >> ba3.html