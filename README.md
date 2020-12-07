# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

Used mailcatcher to send emails.

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
     - request body params: <br>
     { <br>
       &nbsp;&nbsp;&nbsp;&nbsp;page: 1 <br>
     } <br>
     - response data:<br>
     {<br>
       &nbsp;&nbsp;&nbsp;&nbsp;"family": {<br>
           &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"blmFamilyItemsRemaining": 0,<br>
           &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"blm": [<br>
               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"id": 3,<br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"name": "BLM 1",<br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"details": {<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"description": "",<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"location": "NE 23, Lincoln County, Nebraska, 69029, United States of America",<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"precinct": "Police",<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"dob": "2020-10-23T00:00:00.000Z",<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"rip": "2020-11-23T00:00:00.000Z",<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"state": "Negros Occidental",<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"country": "Philippines"<br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}, <br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"backgroundImage": null,<br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"profileImage": null,<br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"imagesOrVideos": null,<br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"relationship": "Brother",<br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"page_creator": {<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"id": 1,<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"provider": "email",<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"uid": "marcuelo1@gmail.com",<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"allow_password_change": false,<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"first_name": "paul",<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"last_name": "marcuelo",<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"phone_number": "09171058588",<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"email": "marcuelo1@gmail.com",<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"username": "marcuelo1",<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"verification_code": "438",<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"is_verified": true,<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"created_at": "2020-12-03T13:18:03.407Z",<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"updated_at": "2020-12-07T00:40:40.683Z",<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"guest": false,<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"account_type": 1,<br>
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"image": null<br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}, <br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"privacy": "public", <br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"manage": true, <br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"famOrFriends": true, <br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"follower": false, <br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"familyCount": 1, <br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"friendsCount": 0, <br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"postsCount": 1, <br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"followersCount": 1, <br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"page_type": "Blm", <br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"hideFamily": false, <br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"hideFriends": false, <br>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"hideFollowers": false <br>
               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;} <br>
           &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;], <br>
           &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"memorialFamilyItemsRemaining": 0, <br>
           &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"memorial": [] <br>
       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}, <br>
       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"friends": { <br>
           &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"blmFriendsItemsRemaining": 0, <br>
           &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"blm": [], <br>
           &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"memorialFriendsItemsRemaining": 0, <br>
           &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"memorial": [] <br>
       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;} <br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;} <br>
   - Feed
     - url: {{BASE_URL}}/mainpages/feed
     - method: 'GET'
     - request body params: <br>
       { <br>
         &nbsp;&nbsp;&nbsp;&nbsp;page: 1 <br>
       } <br>
     - response data: <br>
        { <br>
             "itemsremaining": 0, <br>
             "posts": [ <br>
                 { <br>
                     "id": 4, <br>
                     "page": { <br>
                         "id": 3, <br>
                         "name": "BLM 1", <br>
                         "details": { <br>
                             "description": "", <br>
                             "location": "NE 23, Lincoln County, Nebraska, 69029, United States of America", <br>
                             "precinct": "Police", <br>
                             "dob": "2020-10-23T00:00:00.000Z", <br>
                             "rip": "2020-11-23T00:00:00.000Z", <br>
                             "state": "Negros Occidental", <br>
                             "country": "Philippines" <br>
                         }, <br>
                         "backgroundImage": null, <br>
                         "profileImage": null, <br>
                         "imagesOrVideos": null, <br>
                         "relationship": "Brother", <br>
                         "page_creator": { <br>
                             "id": 1, <br>
                             "provider": "email", <br>
                             "uid": "marcuelo1@gmail.com", <br>
                             "allow_password_change": false, <br>
                             "first_name": "paul", <br>
                             "last_name": "marcuelo", <br>
                             "phone_number": "09171058588", <br>
                             "email": "marcuelo1@gmail.com", <br>
                             "username": "marcuelo1", <br>
                             "verification_code": "438", <br>
                             "is_verified": true, <br>
                             "created_at": "2020-12-03T13:18:03.407Z", <br>
                             "updated_at": "2020-12-07T00:40:40.683Z", <br>
                             "guest": false, <br>
                             "account_type": 1, <br>
                             "image": null <br>
                         }, <br>
                         "privacy": "public", <br>
                         "manage": true, <br>
                         "famOrFriends": true, <br>
                         "follower": false, <br>
                         "familyCount": 1, <br>
                         "friendsCount": 0, <br>
                         "postsCount": 1, <br>
                         "followersCount": 1, <br>
                         "page_type": "Blm", <br>
                         "hideFamily": false, <br>
                         "hideFriends": false, <br>
                         "hideFollowers": false <br>
                     }, <br>
                     "body": "First Post in Blm 1", <br>
                     "location": "Bacolod", <br>
                     "latitude": 0.2323232, <br>
                     "longitude": 0.2323232, <br>
                     "imagesOrVideos": null, <br>
                     "user": { <br>
                         "id": 1, <br>
                         "provider": "email", <br>
                         "uid": "marcuelo1@gmail.com", <br>
                         "allow_password_change": false, <br>
                         "first_name": "paul", <br>
                         "last_name": "marcuelo", <br>
                         "phone_number": "09171058588", <br>
                         "email": "marcuelo1@gmail.com", <br>
                         "username": "marcuelo1", <br>
                         "verification_code": "438", <br>
                         "is_verified": true, <br>
                         "created_at": "2020-12-03T13:18:03.407Z", <br>
                         "updated_at": "2020-12-07T00:40:40.683Z", <br>
                         "guest": false, <br>
                         "account_type": 1, <br>
                         "image": null <br>
                     }, <br>
                     "tag_people": [], <br>
                     "created_at": "2020-12-04T13:22:01.071Z" <br>
                 } <br>
             ] <br>
        } <br>
   - Posts
     - url: {{BASE_URL}}/mainpages/posts
     - method: 'GET'
     - request body params: <br>
       { <br>
         page: 1 <br>
       } <br>
     - response data: <br>
       { <br>
          "itemsremaining": 0, <br>
          "posts": [ <br>
              { <br>
                  "id": 4, <br>
                  "page": { <br>
                      "id": 3, <br>
                      "name": "BLM 1", <br>
                      "details": { <br>
                          "description": "", <br>
                          "location": "NE 23, Lincoln County, Nebraska, 69029, United States of America", <br>
                          "precinct": "Police", <br>
                          "dob": "2020-10-23T00:00:00.000Z", <br>
                          "rip": "2020-11-23T00:00:00.000Z", <br>
                          "state": "Negros Occidental", <br>
                          "country": "Philippines" <br>
                      }, <br>
                      "backgroundImage": null, <br>
                      "profileImage": null, <br>
                      "imagesOrVideos": null, <br>
                      "relationship": "Brother", <br>
                      "page_creator": { <br>
                          "id": 1, <br>
                          "provider": "email", <br>
                          "uid": "marcuelo1@gmail.com", <br>
                          "allow_password_change": false, <br>
                          "first_name": "paul", <br>
                          "last_name": "marcuelo", <br>
                          "phone_number": "09171058588", <br>
                          "email": "marcuelo1@gmail.com", <br>
                          "username": "marcuelo1", <br>
                          "verification_code": "438", <br>
                          "is_verified": true, <br>
                          "created_at": "2020-12-03T13:18:03.407Z", <br>
                          "updated_at": "2020-12-07T00:40:40.683Z", <br>
                          "guest": false, <br>
                          "account_type": 1, <br>
                          "image": null <br>
                      }, <br>
                      "privacy": "public", <br>
                      "manage": true, <br>
                      "famOrFriends": true, <br>
                      "follower": false, <br>
                      "familyCount": 1, <br>
                      "friendsCount": 0, <br>
                      "postsCount": 1, <br>
                      "followersCount": 1, <br>
                      "page_type": "Blm", <br>
                      "hideFamily": false, <br>
                      "hideFriends": false, <br>
                      "hideFollowers": false <br>
                  }, <br>
                  "body": "First Post in Blm 1", <br>
                  "location": "Bacolod", <br>
                  "latitude": 0.2323232, <br>
                  "longitude": 0.2323232, <br>
                  "imagesOrVideos": null, <br>
                  "user": { <br>
                      "id": 1, <br>
                      "provider": "email", <br>
                      "uid": "marcuelo1@gmail.com", <br>
                      "allow_password_change": false, <br>
                      "first_name": "paul", <br>
                      "last_name": "marcuelo", <br>
                      "phone_number": "09171058588", <br>
                      "email": "marcuelo1@gmail.com", <br>
                      "username": "marcuelo1", <br>
                      "verification_code": "438", <br>
                      "is_verified": true, <br>
                      "created_at": "2020-12-03T13:18:03.407Z", <br>
                      "updated_at": "2020-12-07T00:40:40.683Z", <br>
                      "guest": false, <br>
                      "account_type": 1, <br>
                      "image": null <br>
                  }, <br>
                  "tag_people": [], <br>
                  "created_at": "2020-12-04T13:22:01.071Z" <br>
              } <br>
          ] <br>
      } <br>
   - Notifications
     - url: {{BASE_URL}}/mainpages/notifications
     - method: 'GET'
     - request body params: <br>
       { <br>
         page: 1 <br>
       } <br>
     - response data: <br>
       { <br>
            "itemsremaining": 0, <br>
            "notifs": [ <br>
                { <br>
                    "id": 4, <br>
                    "created_at": "2020-12-04T13:28:59.012Z", <br>
                    "updated_at": "2020-12-04T13:28:59.012Z", <br>
                    "recipient_id": 1, <br>
                    "actor_id": 1, <br>
                    "read": false, <br>
                    "action": "paul replied to your comment", <br>
                    "url": "posts/4" <br>
                } <br>
            ] <br>
        } <br>
 ### Search
  - Search Posts
     - url: {{{BASE_URL}}/search/posts
     - method: 'GET'
     - request body params: <br>
       { <br>
         page:1 <br>
         keywords:first <br>
       } <br>
     - response data: <br>
        { <br>
           "itemsremaining": 0, <br>
           "posts": [ <br>
               { <br>
                   "id": 4, <br>
                   "page": { <br>
                       "id": 3, <br>
                       "name": "BLM 1", <br>
                       "details": { <br>
                           "description": "", <br>
                           "location": "NE 23, Lincoln County, Nebraska, 69029, United States of America", <br>
                           "precinct": "Police", <br>
                           "dob": "2020-10-23T00:00:00.000Z", <br>
                           "rip": "2020-11-23T00:00:00.000Z", <br>
                           "state": "Negros Occidental", <br>
                           "country": "Philippines" <br>
                       }, <br>
                       "backgroundImage": null, <br>
                       "profileImage": null, <br>
                       "imagesOrVideos": null, <br>
                       "relationship": "Brother", <br>
                       "page_creator": { <br>
                           "id": 1, <br>
                           "provider": "email", <br>
                           "uid": "marcuelo1@gmail.com", <br>
                           "allow_password_change": false, <br>
                           "first_name": "paul", <br>
                           "last_name": "marcuelo", <br>
                           "phone_number": "09171058588", <br>
                           "email": "marcuelo1@gmail.com", <br>
                           "username": "marcuelo1", <br>
                           "verification_code": "438", <br>
                           "is_verified": true, <br>
                           "created_at": "2020-12-03T13:18:03.407Z", <br>
                           "updated_at": "2020-12-07T00:40:40.683Z", <br>
                           "guest": false, <br>
                           "account_type": 1, <br>
                           "image": null <br>
                       }, <br>
                       "privacy": "public", <br>
                       "manage": true, <br>
                       "famOrFriends": true, <br>
                       "follower": false, <br>
                       "familyCount": 1, <br>
                       "friendsCount": 0, <br>
                       "postsCount": 1, <br>
                       "followersCount": 1, <br>
                       "page_type": "Blm", <br>
                       "hideFamily": false, <br>
                       "hideFriends": false, <br>
                       "hideFollowers": false <br>
                   }, <br>
                   "body": "First Post in Blm 1", <br>
                   "location": "Bacolod", <br>
                   "latitude": 0.2323232, <br>
                   "longitude": 0.2323232, <br>
                   "imagesOrVideos": null, <br>
                   "user": { <br>
                       "id": 1, <br>
                       "provider": "email", <br>
                       "uid": "marcuelo1@gmail.com", <br>
                       "allow_password_change": false, <br>
                       "first_name": "paul", <br>
                       "last_name": "marcuelo", <br>
                       "phone_number": "09171058588", <br>
                       "email": "marcuelo1@gmail.com", <br>
                       "username": "marcuelo1", <br>
                       "verification_code": "438", <br>
                       "is_verified": true, <br>
                       "created_at": "2020-12-03T13:18:03.407Z", <br>
                       "updated_at": "2020-12-07T00:40:40.683Z", <br>
                       "guest": false, <br>
                       "account_type": 1, <br>
                       "image": null <br>
                   }, <br>
                   "tag_people": [], <br>
                   "created_at": "2020-12-04T13:22:01.071Z" <br>
               } <br>
           ] <br>
       } <br>
  - Search Memorials
     - url: {{{BASE_URL}}/search/memorials
     - method: 'GET'
     - request body params: <br>
       { <br>
         page:1 <br>
         keywords:first <br>
       } <br>
     - response data: <br>
       { <br>
          "itemsremaining": 2, <br>
          "memorials": [ <br>
              { <br>
                  "id": 3, <br>
                  "name": "BLM 1", <br>
                  "details": { <br>
                      "description": "", <br>
                      "location": "NE 23, Lincoln County, Nebraska, 69029, United States of America", <br>
                      "precinct": "Police", <br>
                      "dob": "2020-10-23T00:00:00.000Z", <br>
                      "rip": "2020-11-23T00:00:00.000Z", <br>
                      "state": "Negros Occidental", <br>
                      "country": "Philippines" <br>
                  }, <br>
                  "backgroundImage": null, <br>
                  "profileImage": null, <br>
                  "imagesOrVideos": null, <br>
                  "relationship": "Brother", <br>
                  "page_creator": { <br>
                      "id": 1, <br>
                      "provider": "email", <br>
                      "uid": "marcuelo1@gmail.com", <br>
                      "allow_password_change": false, <br>
                      "first_name": "paul", <br>
                      "last_name": "marcuelo", <br>
                      "phone_number": "09171058588", <br>
                      "email": "marcuelo1@gmail.com", <br>
                      "username": "marcuelo1", <br>
                      "verification_code": "438", <br>
                      "is_verified": true, <br>
                      "created_at": "2020-12-03T13:18:03.407Z", <br>
                      "updated_at": "2020-12-07T00:40:40.683Z", <br>
                      "guest": false, <br>
                      "account_type": 1, <br>
                      "image": null <br>
                  }, <br>
                  "privacy": "public", <br>
                  "manage": true, <br>
                  "famOrFriends": true, <br>
                  "follower": false, <br>
                  "familyCount": 1, <br>
                  "friendsCount": 0, <br>
                  "postsCount": 1, <br>
                  "followersCount": 1, <br>
                  "page_type": "Blm", <br>
                  "hideFamily": false, <br>
                  "hideFriends": false, <br>
                  "hideFollowers": false <br>
              } <br>
          ] <br>
      } <br>
  - Search Users
     - url: {{{BASE_URL}}/search/users
     - method: 'GET'
     - request body params: <br>
       { <br>
         page:1 <br>
         keywords:first <br>
       } <br>
     - response data: <br>
        { <br>
            "itemsremaining": 0, <br>
            "users": [ <br>
                { <br>
                    "id": 2, <br>
                    "provider": "email", <br>
                    "uid": "marcuelo2@gmail.com", <br>
                    "allow_password_change": false, <br>
                    "first_name": "paul", <br>
                    "last_name": "marcuelo", <br>
                    "phone_number": "09171058588", <br>
                    "email": "marcuelo2@gmail.com", <br>
                    "username": "marcuelo1", <br>
                    "verification_code": "832", <br>
                    "is_verified": true, <br>
                    "created_at": "2020-12-03T13:19:22.726Z", <br>
                    "updated_at": "2020-12-04T08:39:53.514Z", <br>
                    "guest": false, <br>
                    "account_type": 2 <br>
                } <br>
            ] <br>
        } <br>
  - Search Followers
     - url: {{BASE_URL}}/search/followers/Memorial/1    ||  /search/followers/{{page_type}}/{{page_id}}
     - method: 'GET'
     - request body params: <br>
       { <br>
         page:1 <br>
         keywords:first <br>
       } <br>
     - response data: <br>
  - Search nearby
  - Suggested

