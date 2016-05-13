function setupClickHandlers(){
  var instagramRemoveIcons = document.querySelectorAll("#instagram .icon-remove");
  var twitterRemoveIcons = document.querySelectorAll("#twitter .icon-remove");
  var hashtagRemoveIcons = document.querySelectorAll("#hashtags .icon-remove");
  var twitterLoginLink = document.querySelector(".twitterLogin");

  twitterLoginLink.addEventListener("click", function(){
    var xhr = new XMLHttpRequest();
    xhr.open("get", `${window.location.origin}/admin/twitter_callback`);
    xhr.send();
  });

  for(var i = 0; i < instagramRemoveIcons.length; i++){
    let handler = removeInstagramAccount.bind(document, i);
    instagramRemoveIcons[i].addEventListener("click", handler);
  }

  for(var i = 0; i < twitterRemoveIcons.length; i++){
    let handler = removeTwitterAccount.bind(document, i);
    twitterRemoveIcons[i].addEventListener("click", handler);
  }

  for(var i = 0; i < hashtagRemoveIcons.length; i++){
    let handler = removeHashtag.bind(document, i);
    hashtagRemoveIcons[i].addEventListener("click", handler);
  }

  var addHashtagIcon = document.querySelector("#hashtags .icon-add");
  addHashtagIcon.addEventListener("click", addHashtag);
}

function removeInstagramAccount(index){
  console.log(`removing instagram account at index: ${index}`);
}

function removeTwitterAccount(index){
  console.log(`removing twitter account at index: ${index}`);
}

function removeHashtag(index){
  console.log(`removing hashtag at index: ${index}`);
}

function addHashtag(){
  console.log("adding new hashtag");
}

window.onload = setupClickHandlers;
