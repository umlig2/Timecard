function checkInputVal(obj){
    if(obj.value.length > 1 && obj.value.charAt(0) == '0') obj.value = obj.value.substr(1,obj.value.length); 
    if(!obj.init){ obj.init=1; }
    return calc(obj); 
}

function hPrintClick(me){
    // grab the table and render it into a document of it's own (for printing)
    var tmp = document.getElementById('ivTimecard').outerHTML;

    var html = '<html><head>'
    + document.getElementsByTagName('link')[0].outerHTML
    + document.getElementById('ivTimecardCSS').outerHTML
    + '<style>'
    + 'input{ border:0; background:transparent; }'
    + 'select{ border:0; background:transparent; outline:none; }'
    + 'body{ background-image:none; background-color:#fff; }'
    + '</style>'
    + '</head><body>'
    + '<form id="print_form">'
    + tmp
    + '<div style="position:absolute;top:5px;right:5px;"><button onclick="window.close();">Close</button>'
    + '</form>'
    + '</body></html>'
        
    var win = window.open('about:blank','ivTimecardPrint','');

    win.document.open();
    win.document.write( html );
    win.document.close();

    // replace the form elements with HTML containers and the value of the replaced form input
    var f   = me.form;
    var f2  = win.document.getElementById('print_form');
    for(var i=0; i<f.elements.length; i++){
        var el = f.elements[i];
        if( el.name && el.value ) {
            switch( el.type ) {
                case 'button': 
                case 'select-one':
                case 'text': 
                    try {
                        var el2 = f2[ el.name ];
                            el2.style.display = 'none';
                            if ( el.type != 'button' ) {
                                el2.outerHTML = el.value;
                            }
                    } catch(e) {}
                    break;
            }
        }
    }

    setTimeout( function() {
        win.print();
    }, 100 );

    return false;
}


function topRow() {
    var html = '';

    html += ''
    + '<table>'
    + '<tr>'
    + '<td style="padding:5px;">'
    + '<label for="label" title="Optional label such as name, id, period, etc."><u>L</u>abel:</label>&nbsp;'
    + '<input accesskey="l" name="label">'
    + '</td>'
    + '<td>'
    + '<label for="rate" title="Optional rate. (Do not rely on this for math.)">Rate:</label>&nbsp;'
    + '<input name="rate">'
    + '<input type="button" value="Estimate" '
    + '    title="Attempt to calculate. (Please double-check any math this does!)" ' 
    + '    onclick="calc_by_rate(this)">'
    + '<td>'
    + '</tr>'
    + '</table>'

    return html;
}


function headerRow(){
    if(!window.headerIdx) window.headerIdx=0;
    window.headerIdx++;
    var html = ''
    + '  <tr>'
    + '    <td colspan="4" align="right"><b>Totals:</b></td>'
    + '    <td id="elTotalNormal'+window.headerIdx+'"></td>'
    + '    <td id="elTotalOvertime'+window.headerIdx+'"></td>'
    + '    <td id="elTotalHours'+window.headerIdx+'"></td>'
    + '  </tr>'
    return html;
}


// build up HTML form inputs
function buildHTMLRows(){
    var html = ''
    + headerRow()
  
    for(var i=1; i<17; i++){
        html += ''
        +'  <tr class="data_row '+(i%2?'odd':'even')+'">'
        +'    <td><u>'+i.toString().substr(0,1)+'</u>'+(i.toString().length>0?i.toString().substr(1,i.toString().length-1):'')+'</td>'
        +'    <td><input name="start_hr'+i+'" value="00" class="t1" onchange="return checkInputVal(this); " accesskey="'+i.toString().substr(0,1)+'"> :'
        +'        <input name="start_min'+i+'" value="00" class="t1" onchange="return calc(this)"> '
        +'        <select name="start_time'+i+'" onchange="return calc(this)">'
        +'        <option>AM<option>PM'
        +'        </select>'
        +'    </td>'
        +'    <td><input name="end_hr'+i+'" value="00" class="t1" onchange="if(!this.init){ this.init=1; this.form.end_time'+i+'.options.selectedIndex=1; }; return calc(this)"> :'
        +'        <input name="end_min'+i+'" value="00" class="t1" onchange="return calc(this)"> '
        +'        <select name="end_time'+i+'" onchange="return calc(this)">'
        +'        <option>AM<option>PM'
        +'        </select>'
        +'    </td>'
        +'    <td><input name="break_hr'+i+'" value="00" class="t1" onchange="return calc(this)"> :'
        +'        <input name="break_min'+i+'" value="00" class="t1" onchange="return calc(this)"> '
        +'    </td>'
        +'    <td><div id="rowNormal'+i+'"></div></div></td>'
        +'    <td><div id="rowOvertime'+i+'"></div></td>'
        +'    <td><div id="rowTotal'+i+'"></div><div id="note'+i+'"></div></td>'
        +'    <td><input type="text" name="date' + i + '" style="width:80px;"></td>'
        +'    <td></td>'
        +'  </tr>'
    }

    html += headerRow()
    return html
}

function tsWrapper(){
    var p=location.host || location.pathname;
    var html = ''
    if(p.match(/esqsoft/)){ 
        html += ''
        + '<div id="ivTimecard">'
        + topRow()
        + '<table cellpadding="4" cellspacing="0" width="100%" style="background-color:#fff;">'
        + '  <tr style="background:#ddd;" class="header_row" valign="top">'
        + '    <td>Row</td>'
        + '    <td>Starting Time <div class="sm">(HH:MM)</div></td>'
        + '    <td>Ending Time <div class="sm">(HH:MM)</div></td>'
        + '    <td>Lunch/Breaks <div class="sm">(HH:MM)</div></td>'
        + '    <td>Normal <div class="sm"></div></td>'
        + '    <td>Overtime <div class="sm"></div></td>'
        + '    <td>Total</td>'
        + '    <td title="Optional Date">Date</td>'
        + '    <td width="100%" id="ivnX">&nbsp;</td>'
        + '  </tr>'
        + buildHTMLRows()
        + '</table>'
        + '</div>'
    }
    else{
        html += '<div>Please use this tool from my <a href="http://www.esqsoft.com">website</a>.</div>'
    }
    document.write(html);
}

tsWrapper();
