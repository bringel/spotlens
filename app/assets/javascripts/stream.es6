var currentTwitterPhotoID, currentInstagramPhotoID, moreTwitterPhotos, moreInstagramPhotos;
var sources = ["instagram", "twitter"];

function flipCoin(){
  return Math.floor(Math.random() * 2);
}

function photoTimerFired(){
  var result = flipCoin();

  if(this.sources[result] === "instagram"){

  }
  else{

  }
}

function getNextInstagramPhoto(currentID){
  var promise = new Promise(function(resolve, reject){
    let request = new XMLHttpRequest();
    request.open("get", `${window.location.origin}/stream/next_instagram_photo?current=${currentID}`);
    request.onload = function(){
      if(request.status >= 200 && request.status < 300){
        resolve(request.response);
      }
      else{
        reject(request.status);
      }
    };
    request.send();
  });
  return promise;
}
