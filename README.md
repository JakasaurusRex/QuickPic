QUICKPIC
# Project 3 - *QuickPic*

**QuickPic** is a photo sharing app using Parse as its backend.

Time spent: **16** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can sign up to create a new account using Parse authentication
- [X] User can log in and log out of his or her account
- [X] The current signed in user is persisted across app restarts
- [X] User can take a photo, add a caption, and post it to "Instagram"
- [X] User can view the last 20 posts submitted to "Instagram"
- [X] User can pull to refresh the last 20 posts submitted to "Instagram"
- [X] User can tap a post to view post details, including timestamp and caption

The following **optional** features are implemented:

- [X] Run your app on your phone and use the camera to take the photo
- [ ] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling - I only added 4 posts to the app so I didn't do this one
- [X] Show the username and creation time for each post
- [X] User can use a Tab Bar to switch between a Home Feed tab (all posts) and a Profile tab (only posts published by the current user)
- User Profiles:
  - [X] Allow the logged in user to add a profile photo
  - [X] Display the profile photo with each post
  - [X] Tapping on a post's username or profile photo goes to that user's profile page
- [ ] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse - my posts went up instantly so I didn't see the point of this
- [ ] User can comment on a post and see all comments for each post in the post details screen 
- [X] User can like a post and see number of likes for each post in the post details screen
- [X] Style the login page to look like the real Instagram login page
- [X] Style the feed to look like the real Instagram feed
- [ ] Implement a custom camera view 

The following **additional** features are implemented:

- [X] User can reset their password
- [X] New users get a new user experience to tell them how to get started on the app and make sure their account is secure
- [X] Users cannot post until they sumbit an email address
- [X] Users can add their name, pronouns and a bio
- [X] App works on light and dark mode and any orientation

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. How to implement infinite scroll here
2. How to add more features to add more user accessibility

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://imgur.com/gallery/8nLijzj' title='Video Walkthrough' width='' alt='Video Walkthrough' />
![Kapture 2022-06-30 at 16 00 41](https://user-images.githubusercontent.com/48461874/176792481-72bd3816-b3d6-4c4c-9aa3-b3d9300cf7db.gif)

GIF created with [Kap](https://getkap.co/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- Parse

## Notes

Describe any challenges encountered while building the app.

## License

    Copyright [2022] [Jake Torres]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
