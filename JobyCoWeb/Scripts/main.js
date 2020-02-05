
function exportTo(type) {

    $('#dtViewBooking').tableExport({
		filename: 'table_%DD%-%MM%-%YY%',
		format: type,
		cols: '2,3,4'
	});

}

function exportAll(type) {

	$('#dtViewBooking').tableExport({
		filename: 'table_%DD%-%MM%-%YY%-month(%MM%)',
		format: type
	});

}