# Auth0WebAuth

- A project using Auth0.swift to show Login via an iOS app and generating both access_token and refresh_token for sign in and calling an API


## How it works
 - User signs in using this App which uses a auth0 SDK that launches the login within a web view. The user authenticates with the `audience=Identifier_for_API as defined within Auth0` and the `scope = openid profile offline_access api:scopes` where api:scopes represents the set of scopes the user will consent to allow the App to present to the API.
 
 ### Please read the note below before setting up the Client App within Auth0
 - Create a Client within Auth0 and see the link -> https://github.com/auth0/Auth0.swift#web-based-auth-ios-only to set the settings based on your iOS App

 ### Please read the note below before setting up the API within Auth0
 - Make sure while defining the API within Auth0 the toggle for allow offline access is enabled. make sure when creating the API you have defined the Signing algorithm as RS256 and make a note of the identifier for the API within Auth0. This identifier will be used as the API_AUDIENCE in the settings below
 
 
- The required settings are created within Auth0.plist
```
<dict>
	<key>Domain</key>
	<string>{your_auth0_domain}</string>
	<key>ClientId</key>
	<string>{your_auth0_clientId}</string>
	<key>API_AUDIENCE</key>
	<string>{your_API_Identifier as defined in Auth0}</string>
	<key>scope</key>
	<string>openid profile offline_access api:scopes</string>
</dict>
</plist>
```
- The endpoint of the API is defined under Info.plist and is assumed to be http://localhost:3001 - The project for the API is under https://github.com/pushpabrol/nodejs-api-rs
