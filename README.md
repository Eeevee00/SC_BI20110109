# muzik-lokal

Hi, I'm Teo Eve Gene (BI20110109) . I'm a 4th year student studying 
    - Bachelor of Computer with Honours (Network Engineering) 
    - in Faculty of Computing and Informatics University Malaysia Sabah.

Under supervision of Ts. Dr. Chin Pei Yee, my Final Year 2024 Project is on the topic of 
    - Muziklokal: A gamified application for discovering and supporting local music talent

In short, this project strives to keep the local music scene alive and thriving by 
creating a gamified application for discovering and supporting local music talent 
through job and event opportunities. 

The platform will have three users 
1. Seeker
    - music lovers to discover new events through post browsing and ticket buying
    - local musicians to find job opportunities by application
2. Host
    - hosts to create job opportunities and accept/reject applicant 
    - organizer to create events for ticket selling and promotions.

3. Admin 
    - admin to be able to CRUD most modules such as 
        - approve/reject user verification request
        - create notification and sent to all
        - create reward and view all claim list
        - view feedback
    - superadmin to be able to CRUD most modules + CRUD admin management

All in all, gamification are via points collection and redemption , with badges for verified users.
To gain points, is 
    - Upon successful account registration 
    - Upon successful verified 
    - Upon successful payment transaction 
    - Upon successful feedback submission 
    - Upon successful approval of job

________________________________________________________________________
To run this application in Visual Studio, type this at the terminal: 
    flutter run --no-sound-null-safety

To run this application using phone emulator, 
    1. Ensure USB debugging is enabled 
    2. Run command "flutter devices"
    3. Run approproptiate devices name , eg: flutter run -d aa45l7xccimfxw6h --no-sound-null-safety 

To download apk file, run the command below at terminal :
    flutter build apk --release --no-sound-null-safety     

To run as different user, here are some credentials you may used:
1. Seeker       , email: seeker1@gmail.com password:123123
2. Host         , email: host1@gmail.com password:123123
3. Admin        , email: admin@gmail.com password:123123
4. Superadmin   , email: superadmin@gmail.com password:123123123
  
 #   S C _ B I 2 0 1 1 0 1 0 9 
 
 
