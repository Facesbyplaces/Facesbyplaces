# facesbyplaces

---
----
### UI
 - BLM
 - Home
 - Miscellaneous
 - Regular



## BACK END
 ### Authentication
   - Sign Up
   - Sign In
   - Verify Email
   - Image upload
   - Sign Out
   - Login
   - Image Upload
 ### Main Pages
   - Memorials
     - url: {{BASE_URL}}/mainpages/memorials
     - method: 'GET'
     - request body params: 
     {
       page: 1
     }
     - response data:
     {
       "family": {
           "blmFamilyItemsRemaining": 0,
           "blm": [
               {
                   "id": 3,
                   "name": "BLM 1",
                   "details": {
                       "description": "",
                       "location": "NE 23, Lincoln County, Nebraska, 69029, United States of America",
                       "precinct": "Police",
                       "dob": "2020-10-23T00:00:00.000Z",
                       "rip": "2020-11-23T00:00:00.000Z",
                       "state": "Negros Occidental",
                       "country": "Philippines"
                   },
                   "backgroundImage": null,
                   "profileImage": null,
                   "imagesOrVideos": null,
                   "relationship": "Brother",
                   "page_creator": {
                       "id": 1,
                       "provider": "email",
                       "uid": "marcuelo1@gmail.com",
                       "allow_password_change": false,
                       "first_name": "paul",
                       "last_name": "marcuelo",
                       "phone_number": "09171058588",
                       "email": "marcuelo1@gmail.com",
                       "username": "marcuelo1",
                       "verification_code": "438",
                       "is_verified": true,
                       "created_at": "2020-12-03T13:18:03.407Z",
                       "updated_at": "2020-12-07T00:40:40.683Z",
                       "guest": false,
                       "account_type": 1,
                       "image": null
                   },
                   "privacy": "public",
                   "manage": true,
                   "famOrFriends": true,
                   "follower": false,
                   "familyCount": 1,
                   "friendsCount": 0,
                   "postsCount": 1,
                   "followersCount": 1,
                   "page_type": "Blm",
                   "hideFamily": false,
                   "hideFriends": false,
                   "hideFollowers": false
               }
           ],
           "memorialFamilyItemsRemaining": 0,
           "memorial": []
       },
       "friends": {
           "blmFriendsItemsRemaining": 0,
           "blm": [],
           "memorialFriendsItemsRemaining": 0,
           "memorial": []
       }
   }
   - Feed
     - url: {{BASE_URL}}/mainpages/feed
     - method: 'GET'
     - request body params:
       {
         page: 1
       }
     - response data:
        {
             "itemsremaining": 0,
             "posts": [
                 {
                     "id": 4,
                     "page": {
                         "id": 3,
                         "name": "BLM 1",
                         "details": {
                             "description": "",
                             "location": "NE 23, Lincoln County, Nebraska, 69029, United States of America",
                             "precinct": "Police",
                             "dob": "2020-10-23T00:00:00.000Z",
                             "rip": "2020-11-23T00:00:00.000Z",
                             "state": "Negros Occidental",
                             "country": "Philippines"
                         },
                         "backgroundImage": null,
                         "profileImage": null,
                         "imagesOrVideos": null,
                         "relationship": "Brother",
                         "page_creator": {
                             "id": 1,
                             "provider": "email",
                             "uid": "marcuelo1@gmail.com",
                             "allow_password_change": false,
                             "first_name": "paul",
                             "last_name": "marcuelo",
                             "phone_number": "09171058588",
                             "email": "marcuelo1@gmail.com",
                             "username": "marcuelo1",
                             "verification_code": "438",
                             "is_verified": true,
                             "created_at": "2020-12-03T13:18:03.407Z",
                             "updated_at": "2020-12-07T00:40:40.683Z",
                             "guest": false,
                             "account_type": 1,
                             "image": null
                         },
                         "privacy": "public",
                         "manage": true,
                         "famOrFriends": true,
                         "follower": false,
                         "familyCount": 1,
                         "friendsCount": 0,
                         "postsCount": 1,
                         "followersCount": 1,
                         "page_type": "Blm",
                         "hideFamily": false,
                         "hideFriends": false,
                         "hideFollowers": false
                     },
                     "body": "First Post in Blm 1",
                     "location": "Bacolod",
                     "latitude": 0.2323232,
                     "longitude": 0.2323232,
                     "imagesOrVideos": null,
                     "user": {
                         "id": 1,
                         "provider": "email",
                         "uid": "marcuelo1@gmail.com",
                         "allow_password_change": false,
                         "first_name": "paul",
                         "last_name": "marcuelo",
                         "phone_number": "09171058588",
                         "email": "marcuelo1@gmail.com",
                         "username": "marcuelo1",
                         "verification_code": "438",
                         "is_verified": true,
                         "created_at": "2020-12-03T13:18:03.407Z",
                         "updated_at": "2020-12-07T00:40:40.683Z",
                         "guest": false,
                         "account_type": 1,
                         "image": null
                     },
                     "tag_people": [],
                     "created_at": "2020-12-04T13:22:01.071Z"
                 }
             ]
        }
   - Posts
     - url: {{BASE_URL}}/mainpages/posts
     - method: 'GET'
     - request body params:
       {
         page: 1
       }
     - response data:
       {
          "itemsremaining": 0,
          "posts": [
              {
                  "id": 4,
                  "page": {
                      "id": 3,
                      "name": "BLM 1",
                      "details": {
                          "description": "",
                          "location": "NE 23, Lincoln County, Nebraska, 69029, United States of America",
                          "precinct": "Police",
                          "dob": "2020-10-23T00:00:00.000Z",
                          "rip": "2020-11-23T00:00:00.000Z",
                          "state": "Negros Occidental",
                          "country": "Philippines"
                      },
                      "backgroundImage": null,
                      "profileImage": null,
                      "imagesOrVideos": null,
                      "relationship": "Brother",
                      "page_creator": {
                          "id": 1,
                          "provider": "email",
                          "uid": "marcuelo1@gmail.com",
                          "allow_password_change": false,
                          "first_name": "paul",
                          "last_name": "marcuelo",
                          "phone_number": "09171058588",
                          "email": "marcuelo1@gmail.com",
                          "username": "marcuelo1",
                          "verification_code": "438",
                          "is_verified": true,
                          "created_at": "2020-12-03T13:18:03.407Z",
                          "updated_at": "2020-12-07T00:40:40.683Z",
                          "guest": false,
                          "account_type": 1,
                          "image": null
                      },
                      "privacy": "public",
                      "manage": true,
                      "famOrFriends": true,
                      "follower": false,
                      "familyCount": 1,
                      "friendsCount": 0,
                      "postsCount": 1,
                      "followersCount": 1,
                      "page_type": "Blm",
                      "hideFamily": false,
                      "hideFriends": false,
                      "hideFollowers": false
                  },
                  "body": "First Post in Blm 1",
                  "location": "Bacolod",
                  "latitude": 0.2323232,
                  "longitude": 0.2323232,
                  "imagesOrVideos": null,
                  "user": {
                      "id": 1,
                      "provider": "email",
                      "uid": "marcuelo1@gmail.com",
                      "allow_password_change": false,
                      "first_name": "paul",
                      "last_name": "marcuelo",
                      "phone_number": "09171058588",
                      "email": "marcuelo1@gmail.com",
                      "username": "marcuelo1",
                      "verification_code": "438",
                      "is_verified": true,
                      "created_at": "2020-12-03T13:18:03.407Z",
                      "updated_at": "2020-12-07T00:40:40.683Z",
                      "guest": false,
                      "account_type": 1,
                      "image": null
                  },
                  "tag_people": [],
                  "created_at": "2020-12-04T13:22:01.071Z"
              }
          ]
      }
   - Notifications
     - url: {{BASE_URL}}/mainpages/notifications
     - method: 'GET'
     - request body params:
       {
         page: 1
       }
     - response data:
       {
            "itemsremaining": 0,
            "notifs": [
                {
                    "id": 4,
                    "created_at": "2020-12-04T13:28:59.012Z",
                    "updated_at": "2020-12-04T13:28:59.012Z",
                    "recipient_id": 1,
                    "actor_id": 1,
                    "read": false,
                    "action": "paul replied to your comment",
                    "url": "posts/4"
                }
            ]
        }
 ### Search
  - Search Posts
     - url: {{{BASE_URL}}/search/posts
     - method: 'GET'
     - request body params:
       {
         page:1
         keywords:first
       }
     - response data:
        {
           "itemsremaining": 0,
           "posts": [
               {
                   "id": 4,
                   "page": {
                       "id": 3,
                       "name": "BLM 1",
                       "details": {
                           "description": "",
                           "location": "NE 23, Lincoln County, Nebraska, 69029, United States of America",
                           "precinct": "Police",
                           "dob": "2020-10-23T00:00:00.000Z",
                           "rip": "2020-11-23T00:00:00.000Z",
                           "state": "Negros Occidental",
                           "country": "Philippines"
                       },
                       "backgroundImage": null,
                       "profileImage": null,
                       "imagesOrVideos": null,
                       "relationship": "Brother",
                       "page_creator": {
                           "id": 1,
                           "provider": "email",
                           "uid": "marcuelo1@gmail.com",
                           "allow_password_change": false,
                           "first_name": "paul",
                           "last_name": "marcuelo",
                           "phone_number": "09171058588",
                           "email": "marcuelo1@gmail.com",
                           "username": "marcuelo1",
                           "verification_code": "438",
                           "is_verified": true,
                           "created_at": "2020-12-03T13:18:03.407Z",
                           "updated_at": "2020-12-07T00:40:40.683Z",
                           "guest": false,
                           "account_type": 1,
                           "image": null
                       },
                       "privacy": "public",
                       "manage": true,
                       "famOrFriends": true,
                       "follower": false,
                       "familyCount": 1,
                       "friendsCount": 0,
                       "postsCount": 1,
                       "followersCount": 1,
                       "page_type": "Blm",
                       "hideFamily": false,
                       "hideFriends": false,
                       "hideFollowers": false
                   },
                   "body": "First Post in Blm 1",
                   "location": "Bacolod",
                   "latitude": 0.2323232,
                   "longitude": 0.2323232,
                   "imagesOrVideos": null,
                   "user": {
                       "id": 1,
                       "provider": "email",
                       "uid": "marcuelo1@gmail.com",
                       "allow_password_change": false,
                       "first_name": "paul",
                       "last_name": "marcuelo",
                       "phone_number": "09171058588",
                       "email": "marcuelo1@gmail.com",
                       "username": "marcuelo1",
                       "verification_code": "438",
                       "is_verified": true,
                       "created_at": "2020-12-03T13:18:03.407Z",
                       "updated_at": "2020-12-07T00:40:40.683Z",
                       "guest": false,
                       "account_type": 1,
                       "image": null
                   },
                   "tag_people": [],
                   "created_at": "2020-12-04T13:22:01.071Z"
               }
           ]
       }
  - Search Memorials
     - url: {{{BASE_URL}}/search/memorials
     - method: 'GET'
     - request body params:
       {
         page:1
         keywords:first
       }
     - response data:
       {
          "itemsremaining": 2,
          "memorials": [
              {
                  "id": 3,
                  "name": "BLM 1",
                  "details": {
                      "description": "",
                      "location": "NE 23, Lincoln County, Nebraska, 69029, United States of America",
                      "precinct": "Police",
                      "dob": "2020-10-23T00:00:00.000Z",
                      "rip": "2020-11-23T00:00:00.000Z",
                      "state": "Negros Occidental",
                      "country": "Philippines"
                  },
                  "backgroundImage": null,
                  "profileImage": null,
                  "imagesOrVideos": null,
                  "relationship": "Brother",
                  "page_creator": {
                      "id": 1,
                      "provider": "email",
                      "uid": "marcuelo1@gmail.com",
                      "allow_password_change": false,
                      "first_name": "paul",
                      "last_name": "marcuelo",
                      "phone_number": "09171058588",
                      "email": "marcuelo1@gmail.com",
                      "username": "marcuelo1",
                      "verification_code": "438",
                      "is_verified": true,
                      "created_at": "2020-12-03T13:18:03.407Z",
                      "updated_at": "2020-12-07T00:40:40.683Z",
                      "guest": false,
                      "account_type": 1,
                      "image": null
                  },
                  "privacy": "public",
                  "manage": true,
                  "famOrFriends": true,
                  "follower": false,
                  "familyCount": 1,
                  "friendsCount": 0,
                  "postsCount": 1,
                  "followersCount": 1,
                  "page_type": "Blm",
                  "hideFamily": false,
                  "hideFriends": false,
                  "hideFollowers": false
              },
              {
                  "id": 5,
                  "name": "MEMORIAL 1",
                  "details": {
                      "description": "",
                      "birthplace": "cebu",
                      "dob": "2020-10-23T00:00:00.000Z",
                      "rip": "2020-11-23T00:00:00.000Z",
                      "cemetery": "cemetery",
                      "country": "Philippines"
                  },
                  "backgroundImage": null,
                  "profileImage": null,
                  "imagesOrVideos": null,
                  "relationship": null,
                  "page_creator": {
                      "id": 2,
                      "provider": "email",
                      "uid": "marcuelo2@gmail.com",
                      "allow_password_change": false,
                      "first_name": "paul",
                      "last_name": "marcuelo",
                      "phone_number": "09171058588",
                      "email": "marcuelo2@gmail.com",
                      "username": "marcuelo1",
                      "verification_code": "832",
                      "is_verified": true,
                      "created_at": "2020-12-03T13:19:22.726Z",
                      "updated_at": "2020-12-04T08:39:53.514Z",
                      "guest": false,
                      "account_type": 2,
                      "image": null
                  },
                  "manage": false,
                  "famOrFriends": false,
                  "follower": false,
                  "familyCount": 1,
                  "friendsCount": 0,
                  "postsCount": 0,
                  "followersCount": 0,
                  "page_type": "Memorial",
                  "hideFamily": false,
                  "hideFriends": false,
                  "hideFollowers": false
              }
          ]
      }
  - Search Users
     - url: {{{BASE_URL}}/search/users
     - method: 'GET'
     - request body params:
       {
         page:1
         keywords:first
       }
     - response data:
        {
            "itemsremaining": 0,
            "users": [
                {
                    "id": 2,
                    "provider": "email",
                    "uid": "marcuelo2@gmail.com",
                    "allow_password_change": false,
                    "first_name": "paul",
                    "last_name": "marcuelo",
                    "phone_number": "09171058588",
                    "email": "marcuelo2@gmail.com",
                    "username": "marcuelo1",
                    "verification_code": "832",
                    "is_verified": true,
                    "created_at": "2020-12-03T13:19:22.726Z",
                    "updated_at": "2020-12-04T08:39:53.514Z",
                    "guest": false,
                    "account_type": 2
                }
            ]
        }
  - Search Followers
     - url: {{BASE_URL}}/search/followers/Memorial/1    ||  /search/followers/{{page_type}}/{{page_id}}
     - method: 'GET'
     - request body params:
       {
         page:1
         keywords:first
       }
     - response data:
  - Search nearby
  - Suggested
