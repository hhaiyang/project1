var analysis = function(){
    var metas = document.getElementsByTagName('meta');
    var message = {title : '',img : '',desc : '',price:0};
    for(var i = 0;i < metas.length;i++){
        var meta = metas[i];
        if((meta.name.toLowerCase().indexOf('img') != -1 ||
                meta.name.toLowerCase().indexOf('image') != -1 ||
                meta.name.toLowerCase().indexOf('cover') != -1) && (message.img == '' || message.img.indexOf('http') == -1)){
            message.img = meta.content;
        }
        if(meta.name.toLowerCase().indexOf('desc') != -1){
            message.desc = meta.content;
        }
        if(meta.name == 'keywords'){
            var words = meta.content.split(' ');
            for(var k = 0;k < words.length;k++){
                if(words[k].length > message.title.length){
                    message.title = words[k];
                }
            }
        }
        if(meta.name.toLowerCase().indexOf('title') != -1){
            message.title = meta.content;
        }
    }
    
    if(message.img == ''){
        message.img = parseImage();
    }
    if(message.title == ''){
        message.title = document.title;
    }
    
    message.price = parsePrice();
    
    return message;
}

function parsePrice(){
    var price = '';
    var start = 0;
    start = document.body.innerText.indexOf('¥',start);
    if(start == -1){
        start = document.body.innerText.indexOf('￥',start);
        if(start == -1){
            start = document.body.innerText.indexOf('￥',start);
        }
    }
    if(start != -1){
        var fragment = document.body.innerText.substr(start + 1).replace(/,/g,'');
        for(var i = 0;i<fragment.length;i++){
            if(IsNumeric(fragment.charAt(i))){
                price += fragment.charAt(i);
            }
            else{
                break;
            }
        }
    }
    else{
        var start = document.body.innerHTML.indexOf('price">') + 'price">'.length;
        if(start != -1){
            var fragment = document.body.innerHTML.substr(start);
            for(var i = 0;i<fragment.length;i++){
                if(IsNumeric(fragment.charAt(i))){
                    price += fragment.charAt(i);
                }
                else{
                    break;
                }
            }
        }
    }
    return price;
}

function parseImage(){
    var imgs = document.getElementsByTagName('img');
    var largestImg = {
        ratio : 1,
        idx : 0
    };
    for(var i = 0;i < imgs.length; i++){
        var img = imgs[i];
        if(img.src.indexOf('.jpg' || 'base64') == -1){
            console.log('skipped');
            continue;
        }
        var square = img.height * img.width;
        var hwRatio = img.width > img.height ? img.height / img.width : img.width / img.height;
        var delta = Math.pow((i + 1),1) * Math.max(Math.abs(1 - hwRatio),0.01);
        var r = Math.pow(square,hwRatio) / delta;
        if(r > largestImg.ratio){
            largestImg.ratio = r;
            largestImg.idx = i;
        }
    }
    var imgSrc = imgs[largestImg.idx].src;
    return imgSrc;
}

function IsNumeric(sText)
{
    var ValidChars = "0123456789.";
    var IsNumber=true;
    var Char;
    
    
    for (i = 0; i < sText.length && IsNumber == true; i++)
    {
        Char = sText.charAt(i);
        if (ValidChars.indexOf(Char) == -1)
        {
            IsNumber = false;
        }
    }
    return IsNumber;
    
}

function getResult(){
    var message = analysis()
    window.webkit.messageHandlers.script_analysis.postMessage(message);
}