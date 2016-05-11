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
      result = JSON.parse(result);
      currentInstagramPhotoID = result.id;
      var imageTag = new Image();
      var imageContainer = document.getElementById("currentPhoto");
      imageContainer.appendChild(imageTag);
      console.log(result.photo_url)
      imageTag.src = result.photo_url;
    });
  }
  else{

  }
}

function getNextInstagramPhoto(currentID){
  var promise = new Promise(function(resolve, reject){
    let request = new XMLHttpRequest();
    if(currentInstagramPhotoID){
      request.open("get", `${window.location.origin}/stream/next_instagram_photo?current=${currentInstagramPhotoID}`);
    }
    else{
      request.open("get", `${window.location.origin}/stream/next_instagram_photo`);
    }
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
  getNextInstagramPhoto("").then(function(result){
    result = JSON.parse(result);
    currentInstagramPhotoID = result.id;
    var imageTag = new Image();
    var imageContainer = document.getElementById("currentPhoto");
    imageContainer.appendChild(imageTag);
    imageTag.src = result.photo_url;

    var profilePhoto = new Image();
    var profilePhotoContainer = document.getElementById("profile");
    profilePhotoContainer.appendChild(profilePhoto);
    profilePhoto.src = result.instagram_profile_photo;

    var userName = document.getElementById("username");
    var fullName = document.getElementById("fullname");
    userName.textContent = `@${result.instagram_username}`;
    fullName.textContent = result.instagram_fullname;

    var caption = document.getElementById("captionText");
    caption.textContent = result.caption;

    var hearts = document.getElementById("likeCount");
    hearts.textContent = result.likes;
  });
  setTimeout(photoTimerFired, photoSwitchTimer * 1000);
}

window.onload = loaded;
