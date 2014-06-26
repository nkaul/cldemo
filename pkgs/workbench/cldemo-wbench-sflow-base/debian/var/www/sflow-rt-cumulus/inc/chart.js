// Copyright (c) InMon Corp. 2014 ALL RIGHTS RESERVED

function createChart(spec) {

    $.jqplot.sprintf.thousandsSeparator = ',';

    var lines;
    var labels;
    var keyLabels;
    var start;
    var end;
    var maxPoints = 5 * 60;
    var step = 1000;

    var suffixes = ["μ","m",,"K","M","G","T","P","E"];
    function formatValue(format,value,includeMillis) {
	if(value == 0) return $.jqplot.sprintf(format,value);

	var i = 2;
	var divisor = 1;

	if(includeMillis) {
            i = 0;
            divisor = 0.000001;
	}

	var absval = Math.abs(value);
	while(i < suffixes.length) {
            if((absval /divisor) < 1000) break;
            divisor *= 1000;
            i++;
	}
	var scaled = Math.round(absval * 1000 / divisor) / 1000;
	return $.jqplot.sprintf(format,scaled) + (suffixes[i] ? suffixes[i] : "");
    }

    function getValueFormatter(suppressMillis) {
	return function(format,value) {
	    return formatValue(format,value,suppressMillis);
	}
    }

    function buildTopNTablePanel(spec, data) {
	var panel = $('<div id="topn"></div>').addClass('topn');
	if(spec.title) {
	    var title = $('<h1></h2>').addClass('topntitle').text(spec.title);
	    panel.append(title);
	}
	var table = $('<table></table>').addClass('topntable');
	if(spec.legend) {
	    var headers = $('<thead></thead>').addClass('topnhead');
	    for(var ll in spec.legend) {
		var hdr = $('<th></th>').addClass('topnheadcell').text(spec.legend[ll]);
		headers.append(hdr);
	    }
	    table.append(headers);
	}
	
	var topKeys = data[0].topKeys;
	if(topKeys) {
	    var odd = true;
            var scale = spec.scale ? spec.scale : 1; 
	    for(var k in topKeys) {
		var row = $('<tr></tr>').addClass(odd ? 'odd' : 'even');
		var keys = topKeys[k].key.split(",");
		for(var col in keys) {
		    var cell = $('<td></td>').addClass('topnkeycell').text(keys[col]);
		    row.append(cell);
		}
		var vcell =  $('<td></td>').addClass('topnvalcell').text(formatValue("%.1f", topKeys[k].value * scale, false));
		row.append(vcell);
		table.append(row);
		odd = !odd;
	    }
	}
	panel.append(table);
	return panel;
    }
    
    function updateChart(data) {
	if(!data || data.length == 0) return;

	var now = new Date(); 

	var endMs = now.getTime();   
	endMs -= endMs % step;
	end = new Date(endMs);

	var startMs = now.getTime() - (maxPoints * step);
	startMs -= startMs % step;
	start = new Date(startMs);
	
	if(!lines) {
            lines = [];
            for(var l = 0; l < data.length; l++) {
		var points = [];
		lines.push(points);
            }
	}

	labels = [];
	for(var l = 0; l < data.length; l++) {
            labels.push(data[l].metricName);
            var points = lines[l];
            var scale = spec.scale ? spec.scale : 1; 
            var val = data[l].metricValue ? data[l].metricValue * scale : 0;
            points.push([end, val]);
            while(points[0][0].getTime() < startMs) points.shift();
	}

	keyLabels = [];
	if(spec.showKeys && data[0].topKeys) {
	    for(var k in data[0].topKeys) {
		var key = data[0].topKeys[k];
		var toks = key.key.split(",");
		keyLabels.push(toks.join(" -- "));
	    }
	} 
	
	var options = {
            axesDefaults: {
		labelRenderer: $.jqplot.CanvasAxisLabelRenderer
            },
            seriesDefaults: {
		showMarker: false,
		fill: false,
		rendererOptions: {
                    highlightMouseOver: false,
                    highlightMouseDown: false,
                    highlightColor: null
		}
            },
            axes:{
		xaxis:{
                    min: start,
                    max: end,
                    renderer: $.jqplot.DateAxisRenderer,
                    tickOptions: {
			formatString: '%H:%M:%S'
                    }
		}, 
		yaxis:{
                    min: 0,
                    tickOptions: {
			formatString: "%g",
			formatter: getValueFormatter(false)
                    },
                    labelOptions: {
			fontSize: '10pt',
			fontFamily: 'Arial, Helvetica, sans-serif'
                    }
		}
            }
	};
	if(spec.title) options.title = spec.title;
	if(spec.colors) options.seriesColors = spec.colors;
	if(spec.units) options.axes.yaxis.label = spec.units;
	if(spec.legend || spec.showKeys || labels.length > 1) {
            options.legend = {
		renderer: $.jqplot.EnhancedLegendRenderer,
		rendererOptions: {
		    numberRows: 1,
		    seriesToggle: false 
		},
		show:true,
		placement: 'outsideGrid',
		location: 's',
		labels: spec.legend ? spec.legend : (spec.showKeys ? keyLabels : labels)
            };
	};
	
	var plot = $('#'+spec.id).data('jqplot');
	if(plot) plot.destroy();

	if(spec.showTable) {
	    var panel = buildTopNTablePanel(spec, data);
	    $('#'+spec.id).empty().append(panel);
	}
	else {
	    $('#'+spec.id).empty().jqplot(lines,options);
	}
    }

    $(window).resize(function() {
	var plot = $('#'+spec.id).data('jqplot');
	if(plot) plot.replot();
    });

    (function poll() {
	$.ajax({
            url: spec.url,
            success: function(data) {
                updateChart(data);
                setTimeout(poll, step);
            },
            error: function(result,status,errorThrown) {
                $('#'+spec.id).empty().append('<span class="warn">' + status + (errorThrown ? '&nbsp;&nbsp;' + errorThrown : '') + '</span>');
            },
            dataType: "json",
            timeout: 60000
        });
    })();
}

