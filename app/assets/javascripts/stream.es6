var currentTwitterPhotoID, currentInstagramPhotoID, moreTwitterPhotos, moreInstagramPhotos;

function flipCoin(){
  var sources = ["instagram", "twitter"];
  var flipped = Math.floor(Math.random() * 2);

  return sources[flipped];
}

function photoTimerFired(){
  var result = flipCoin();
  if(result === "instagram"){
    getNextInstagramPhoto(currentInstagramPhotoID).then(function(response){
      response = JSON.parse(response);
      parseAndDisplayPhotoData(response, result);
    });
  }
  else if(result == "twitter"){
    getNextTwitterPhoto(currentTwitterPhotoID).then(function(response){
      response = JSON.parse(response);
      parseAndDisplayPhotoData(response, result)
    })
  }
}

function getNextInstagramPhoto(currentID){
  var promise = new Promise(function(resolve, reject){
    let request = new XMLHttpRequest();
    if(currentID){
      request.open("get", `${window.location.origin}/stream/next_instagram_photo?current=${currentID}`);
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

function getNextTwitterPhoto(currentID){
  var promise = new Promise(function(resolve, reject){
    let request = new XMLHttpRequest();
    if(currentID){
      request.open("get", `${window.location.origin}/stream/next_twitter_photo?current=${currentID}`);
    }
    else{
      request.open("get", `${window.location.origin}/stream/next_twitter_photo`);
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
function loaded(){
  getNextTwitterPhoto().then(function(response){
    response = JSON.parse(response);
    parseAndDisplayPhotoData(response, "twitter");
  });
  setTimeout(photoTimerFired, photoSwitchTimer * 1000);
}

function parseAndDisplayPhotoData(result, photoSource){
  var photoUrl, profilePhotoUrl, username, fullname, caption, likes;

  if(photoSource == "instagram"){
    currentInstagramPhotoID = result.id;

    photoUrl = result.photo_url;
    profilePhotoUrl = result.instagram_profile_photo;

    username = `@${result.instagram_username}`;
    fullname = result.instagram_fullname;

    caption = result.caption;
    likes = result.likes;

  }
  else if(photoSource == "twitter"){
    currentTwitterPhotoID = result.id;

    photoUrl = result.photo_url;
    profilePhotoUrl = result.twitter_profile_photo;

    username = `@${result.twitter_username}`;
    fullname = result.twitter_fullname;

    caption = result.tweet_text;
    likes = result.favorites;
  }

  displayPhoto(photoUrl, profilePhotoUrl, username, fullname, caption, likes);
  setTimeout(photoTimerFired, photoSwitchTimer * 1000);
}

function displayPhoto(photoUrl, profilePhotoUrl, username, fullname, caption, likes){

  var imageContainer = document.getElementById("currentPhoto");
  if(imageContainer.children.length > 0 && imageContainer.firstElementChild.tagName.toLowerCase() === "img"){
    imageContainer.firstElementChild.src = photoUrl;
  }
  else{
    var imageTag = new Image();
    imageContainer.appendChild(imageTag);
    imageTag.src = photoUrl;
  }

  var profilePhotoContainer = document.getElementById("profile");
  if(profilePhotoContainer.children.length > 0 && profilePhotoContainer.firstElementChild.tagName.toLowerCase() === "img"){
    profilePhotoContainer.firstElementChild.src = profilePhotoUrl;
  }
  else{
    var profilePhoto = new Image();
    profilePhotoContainer.appendChild(profilePhoto);
    profilePhoto.src = profilePhotoUrl;
  }

  var userNameSpan = document.getElementById("username");
  var fullNameSpan = document.getElementById("fullname");
  userNameSpan.textContent = username;
  fullNameSpan.textContent = fullname;

  var captionSpan = document.getElementById("captionText");
  captionSpan.textContent = caption;

  var heartsCount = document.getElementById("likeCount");
  heartsCount.textContent = likes;
}

window.onload = loaded;
