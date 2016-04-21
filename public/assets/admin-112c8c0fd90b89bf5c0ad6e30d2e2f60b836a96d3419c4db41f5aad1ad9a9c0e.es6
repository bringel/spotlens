function setupClickHandlers(){
  var instagramRemoveIcons = document.querySelectorAll("#instagram .fa-remove");
  var twitterRemoveIcons = document.querySelectorAll("#twitter .fa-remove");
  var hashtagRemoveIcons = document.querySelectorAll("#hashtags .fa-remove");

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

  var addHashtagIcon = document.querySelector("#hashtags .fa-plus");
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
