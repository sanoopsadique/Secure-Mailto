// Email.js version 5
// code credits http://www.bronze-age.com/nospam/encode.html
// no changes needed


var tld_ = new Array()
tld_[0] = "com";
tld_[1] = "org";
tld_[2] = "net";
tld_[3] = "ws";
tld_[4] = "ca";
tld_[10] = "co.uk";
tld_[11] = "org.uk";
tld_[12] = "gov.uk";
tld_[13] = "ac.uk";
var topDom_ = 13;
var m_ = "mailto:";
var a_ = "@";
var d_ = ".";

function mail(name, dom, tl, params)
{
	var s = e(name,dom,tl);
	//document.write('<a href="'+m_+s+params+'">'+s+'</a>');
	subject = "?subject="+get_subject()
    window.location = m_+s+params+subject
}
function mail2(name, dom, tl, params, display)
{
	document.write('<a href="'+m_+e(name,dom,tl)+params+'">'+display+'</a>');
}
function e(name, dom, tl)
{
	var s = name+a_;
	if (tl!=-2)
	{
		s+= dom;
		if (tl>=0)
			s+= d_+tld_[tl];
	}
	else
		s+= swapper(dom);
	return s;
}
function swapper(d)
{
	var s = "";
	for (var i=0; i<d.length; i+=2)
		if (i+1==d.length)
			s+= d.charAt(i)
		else
			s+= d.charAt(i+1)+d.charAt(i);
	return s.replace(/\?/g,'.');
}

function get_subject(){
    var url = location.href;
	var request = url.substring(url.indexOf('?') + 1);
    if(request == url)
		return "Let's Connect"

    var qs = request.split('&');
    //for(var i = 0, result = {}; i < 0; i++){
    	qs[0] = qs[0].split('=');
        //result[qs[i][0]] = qs[i][1];
	
	if(qs[0][1] == '')
		qs[0][1] = "Let's Connect"

    return qs[0][1];
}