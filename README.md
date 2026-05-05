# CS340
Team 73 Project Group for OSU Ecampus CS340

## TO RUN:
1. Load DDL.sql into your db
2. SSH into your account while on the VPN
3. Run `scp -r app yourONID@classwork.engr.oregonstate.edu:~` in CS340 dir to copy file contents over.
4. In SSH, cd to dir, then npm install to install dependencies.
5. Run `nano .env`, and write the following:

    DB_HOST=classmysql.engr.oregonstate.edu
   
    DB_USER=*
   
    DB_PASSWORD=*
   
    DB_NAME=*
   
    DB_CONNECTION_LIMIT=10
   
    PORT=29012

    (replace * with your information)
7. Run `npx forever start app.js`
