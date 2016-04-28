var currentTwitterPhotoID, currentInstagramPhotoID, moreTwitterPhotos, moreInstagramPhotos;

function flipCoin(){
  var sources = ["instagram", "twitter"];
  var flipped = Math.floor(Math.random() * 2);

  return sources[flipped];
}

function photoTimerFired(){
  var result = flipCoin();
  if(result === "instagram"){
    getNextInstagramPhoto(currentInstagramPhotoID).then(function(result){

    });
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

function switchPhoto(photoData){

}

function loaded(){

}
