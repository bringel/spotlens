"use strict";

var currentTwitterPhotoID, currentInstagramPhotoID, moreTwitterPhotos, moreInstagramPhotos, currentTwilioPhotoID;

function flipCoin() {
  var sources = ["instagram", "twitter", "twilio"];
  var flipped = Math.floor(Math.random() * 3);

  return sources[flipped];
}

function photoTimerFired() {
  var result = flipCoin();
  if (result === "instagram") {
    getNextInstagramPhoto(currentInstagramPhotoID).then(function (response) {
      response = JSON.parse(response);
      parseAndDisplayPhotoData(response, result);
    });
  } else if (result === "twitter") {
    getNextTwitterPhoto(currentTwitterPhotoID).then(function (response) {
      response = JSON.parse(response);
      parseAndDisplayPhotoData(response, result);
    });
  } else if (result === "twilio") {
    getNextTwilioPhoto(currentTwilioPhotoID).then(function (response) {
      if (response.ok) {
        parseAndDisplayPhotoData(response.json(), result);
      }
    });
  }
}

function getNextInstagramPhoto(currentID) {
  var promise = new Promise(function (resolve, reject) {
    var request = new XMLHttpRequest();
    if (currentID) {
      request.open("get", window.location.origin + "/stream/next_instagram_photo?current=" + currentID);
    } else {
      request.open("get", window.location.origin + "/stream/next_instagram_photo");
    }
    request.onload = function () {
      if (request.status >= 200 && request.status < 300) {
        resolve(request.response);
      } else {
        reject(request.status);
      }
    };
    request.send();
  });
  return promise;
}

function getNextTwitterPhoto(currentID) {
  var promise = new Promise(function (resolve, reject) {
    var request = new XMLHttpRequest();
    if (currentID) {
      request.open("get", window.location.origin + "/stream/next_twitter_photo?current=" + currentID);
    } else {
      request.open("get", window.location.origin + "/stream/next_twitter_photo");
    }
    request.onload = function () {
      if (request.status >= 200 && request.status < 300) {
        resolve(request.response);
      } else {
        reject(request.status);
      }
    };
    request.send();
  });
  return promise;
}

function getNextTwilioPhoto(currentID) {
  if (currentID) {
    return fetch(window.location.origin + "/stream/next_twilio_photo?current=" + currentID);
  } else {
    return fetch(window.location.origin + "/stream/next_twilio_photo");
  }
}

function loaded() {
  // getNextTwitterPhoto().then(function(response){
  //   response = JSON.parse(response);
  //   parseAndDisplayPhotoData(response, "twitter");
  // });
  // setTimeout(photoTimerFired, photoSwitchTimer * 1000);

  photoTimerFired();
}

function parseAndDisplayPhotoData(result, photoSource) {
  var photoUrl, profilePhotoUrl, username, fullname, caption, likes;

  if (photoSource === "instagram") {
    currentInstagramPhotoID = result.id;

    photoUrl = result.photo_url;
    profilePhotoUrl = result.instagram_profile_photo;

    username = "@" + result.instagram_username;
    fullname = result.instagram_fullname;

    caption = result.caption;
    likes = result.likes;
  } else if (photoSource === "twitter") {
    currentTwitterPhotoID = result.id;

    photoUrl = result.photo_url;
    profilePhotoUrl = result.twitter_profile_photo;

    username = "@" + result.twitter_username;
    fullname = result.twitter_fullname;

    caption = result.tweet_text;
    likes = result.favorites;
  } else if (photoSource === "twilio") {
    currentTwilioPhotoID = result.id;

    photoUrl = result.media_url;
    caption = result.body;
  }

  displayPhoto(photoUrl, profilePhotoUrl, username, fullname, caption, likes);
  setTimeout(photoTimerFired, photoSwitchTimer * 1000);
}

function displayPhoto(photoUrl, profilePhotoUrl, username, fullname, caption, likes) {

  var imageContainer = document.getElementById("currentPhoto");
  if (imageContainer.children.length > 0 && imageContainer.firstElementChild.tagName.toLowerCase() === "img") {
    imageContainer.firstElementChild.src = photoUrl;
  } else {
    var imageTag = new Image();
    imageContainer.appendChild(imageTag);
    imageTag.src = photoUrl;
  }

  var profilePhotoContainer = document.getElementById("profile");
  if (profilePhotoUrl) {
    profilePhotoContainer.style.visibility = '';
    if (profilePhotoContainer.children.length > 0 && profilePhotoContainer.firstElementChild.tagName.toLowerCase() === "img") {
      profilePhotoContainer.firstElementChild.src = profilePhotoUrl;
    } else {
      var profilePhoto = new Image();
      profilePhotoContainer.appendChild(profilePhoto);
      profilePhoto.src = profilePhotoUrl;
    }
  } else {
    profilePhotoContainer.style.visibility = 'hidden';
  }

  var userNameSpan = document.getElementById("username");
  var fullNameSpan = document.getElementById("fullname");
  if (username && fullname) {
    userNameSpan.style.visibility = '';
    fullNameSpan.style.visibility = '';
    userNameSpan.textContent = username;
    fullNameSpan.textContent = fullname;
  } else {
    userNameSpan.style.visibility = 'hidden';
    fullNameSpan.style.visibility = 'hidden';
  }

  var captionSpan = document.getElementById("captionText");
  if (caption) {
    captionSpan.style.visibility = '';
    captionSpan.textContent = caption;
  } else {
    captionSpan.style.visibility = 'hidden';
  }

  var heartsCount = document.getElementById("likeCount");
  var heart = document.getElementById("heartIcon");
  if (likes) {
    heartsCount.style.visibility = '';
    heart.style.visibility = '';
    heartsCount.textContent = likes;
  } else {
    heartsCount.style.visibility = 'hidden';
    heart.style.visibility = 'hidden';
  }
}

window.onload = loaded;
