call sign_up("AbhimanyuBellam","Abhimanyu","Bellam","bellam@gmail.com","1234",@p1);

call sign_up("AbhinavReddy","Abhinav","Reddy","nimma@gmail.com","1234",@p2);

call sign_up("RohithGilla","Rohith","Gilla","gilla@gmail.com","1234",@p3);


call send_request("bellam@gmail.com","gilla@gmail.com",@p4);

call accept_request("bellam@gmail.com","gilla@gmail.com",@p5);

call send_request("gilla@gmail.com","nimma@gmail.com",@p6);

-- call decline_request("gilla@gmail.com","nimma@gmail.com",@p7)


-- call cancel_request("gilla@gmail.com","nimma@gmail.com",@p8);


call sign_in("bellam@gmail.com","1234",@p9);

call send_message("bellam@gmail.com","gilla@gmail.com","HI ROHITH",@p10);


call send_message("gilla@gmail.com","bellam@gmail.com","HI BELLAM",@p11);


call send_message("gilla@gmail.com","nimma@gmail.com","HI NIMMA",@p12);

call check_online("bellam@gmail.com",@p13);



select * from Messages;


call add_post("bellam@gmail.com","First tweet in the dbms",'1.png',@p14);

call add_post("gilla@gmail.com","useless PPL",'1.png',@p19);

call add_post("nimma@gmail.com","useless PPL shit",'1.png',@p20);

call add_like(1,3,@p15);

call add_comment(1,3,"wat shit",@p16);

call un_like(1,3,@p15);

select * from Posts;


call add_photos("ProfilePhotos","bellam@gmail.com",'1.png',@p17);

call add_photos("ProfilePhotos","gilla@gmail.com",'1.png',@p17);

select * from Gallery;


call search("Abhi");

call check_received_friend_requests("nimma@gmail.com");
call check_sent_friend_requests("gilla@gmail.com");


call home("bellam@gmail.com");
call home("nimma@gmail.com");


-- create table Posts(PID int(10) primary key auto_increment,UID int(10),Tweet varchar(1000),Img blob,NumComments int(10),NumLikes int(10),created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
-- select Img, Tweet,NumLikes,NumComments from Posts cross join Friends where Friends.FromUID=t or Friends.ToUID=t; 