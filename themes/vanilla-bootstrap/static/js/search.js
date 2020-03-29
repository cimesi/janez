
document.addEventListener("DOMContentLoaded", function () {
    let searchResults = [];
    const searchInput = document.querySelector("input[name='search']");
    const searchResultElement = document.querySelector("#main-sections");
    const posts = document.querySelectorAll(".post");

    axios.get("/search")
        .then(function (result) {
            const searchContent = result.data;
            const searchIndex = lunr(function () {
                this.ref("url");
                this.field("content");
                this.field("tags");
                this.field("title");

                Array.from(result.data).forEach(function (doc) {
                    this.add(doc)
                }, this)
            })
            searchInput.addEventListener("keyup", function (e) {
                let searchString = e.target.value;
                if (searchString && searchString.length > 1) {
                    try {
                        searchResults = searchIndex.search(searchString);
                    } catch (err) {
                        if (err instanceof lunr.QueryParseError) {
                            return;
                        }
                    }
                } else {
                  searchResults = [];
                }

                if (searchResults.length > 0) {
                  searchResults.map(function (match) {
                    [].forEach.call(posts, function(post) {
                      if (post.querySelector("a").href == match.ref) {
                        post.style.display = "";
                      }
                    });
                  });
                } else {
                  if (searchString < 2) {
                    [].forEach.call(posts, function(post) {
                      post.style.display = "";
                    });
                  } else {
                    [].forEach.call(posts, function(post) {
                      post.style.display = "none";
                    });
                  }
                }
            });
        })
        .catch(function (error) {
            // console.error(error);
        });
});

