drop database dbms_project3;

create database dbms_project3;
use dbms_project3;
create table UserDetails(UID int(10) primary key auto_increment,UserName varchar(20) not null,FName varchar(15) not null,LName varchar(15) not null,Email varchar(30) not null,Pass varchar(30) not null, UNIQUE(Email),online_status varchar(20));

-- insert into UserDetails values(1,"Abhimanyu_Bellam","Abhimanyu","Bellam","bellam@gmail.com","1234","offline");

-- insert into UserDetails values(2,"Rohith_Gilla","Rohith","Gilla","gilla@gmail.com","1234","offline");

create table Friends(FID int(10) primary key auto_increment,ToUID int(10),FromUID int(10), foreign key(ToUID) references UserDetails(UID),foreign key(FromUID) references UserDetails(UID));

-- insert into Friends values(1,2,1);


-- insert into UserDetails values(3,"Abhinav_Reddy","Abhinav","Reddy","reddy@gmail.com","1234","offline");


-- insert into Friends values(3,1,3);


CREATE table Messages(MID int(10) primary key auto_increment,ToUID int(10),FromUID int(10), Msg varchar(1000),created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

-- INSERT into Messages values (1,2,1,"Wassup Gilla");

-- INSERT into Messages values (2,3,1,"Wassup Abhinav");


create table FriendRequests(id int(10) primary key auto_increment,sender varchar(30),receiver varchar(30));


create table Albums(AID int(10) primary key auto_increment,UID int(10),Aname varchar(30), foreign key(UID) references UserDetails(UID));

create table Gallery (GID int(10) primary key auto_increment,AID int(10),Img blob, foreign key(AID) references Albums(AID));


create table Posts(PID int(10) primary key auto_increment,UID int(10),Tweet varchar(1000),Img blob,NumComments int(10),NumLikes int(10),created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

create table Comments(CID int(10) primary key auto_increment,PID int(10),UIDCommenter int(10),Comment varchar(1000),created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,foreign key(PID) references Posts(PID));

create table Likes (LID int(10) primary key auto_increment,PID int(10),liker int(10),created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,foreign key(PID) references Posts(PID));


delimiter #


create procedure add_post(in email varchar(30),in tweet_info varchar(1000), in image_to_Add blob,out response varchar(100))
BEGIN
    declare u_id INTEGER;
    select UID into u_id from UserDetails where UserDetails.Email =email; 
    insert into Posts(UID,Tweet,Img,NumComments,NumLikes) values(u_id,tweet_info,image_to_Add,0,0);
    set response:="Post Added";
    select response as 'response';
END;
#

create PROCEDURE add_comment(in p_id int(10),in u_id_commenter int(10),in Comment_info varchar(1000),out response varchar(100))
BEGIN
    declare t int(10);
    insert into Comments(PID,UIDCommenter,Comment) values(p_id, u_id_commenter,Comment_info);
    
    select NumComments into t from Posts where Posts.PID=p_id;
    update Posts set NumComments=t+1 where Posts.PID=p_id;
    set response:="Comment added";
    select response as 'response';
End;
#

create procedure add_like(in p_id int(10),liker1 int(10),out response varchar(100))
BEGIN
    declare t integer;
    select NumLikes into t from Posts where Posts.PID=p_id;
    if (select count(*) from Likes where Likes.PID=p_id and Likes.liker=liker1) !=0 THEN
        set response:="You already liked post";
        select response as 'response';
    ELSE
        INSERT into Likes(PID,liker) values(p_id,liker1);
        update Posts set NumLikes=t+1 where Posts.PID=p_id;
        set response:="You liked post successfully";
        select response as 'response';
    end if;
END;
#

create procedure un_like(in p_id int(10),liker1 int(10),out response varchar(100))
BEGIN
    declare t integer;
    select NumLikes into t from Posts where Posts.PID=p_id;
    if (select count(*) from Likes where Likes.PID=p_id and Likes.liker=liker1) !=0 THEN
        update Posts set NumLikes=t-1 where Posts.PID=p_id;
        delete from Likes where Likes.PID=p_id and Likes.liker=liker1;
        set response:="Unliked successfully";
        select response as 'response';
    ELSE
        set response:="You didn't like the post";
        select response as 'response';
    end if;    
END;
#

create procedure sign_up(in UserName varchar(20) ,in FName varchar(15) ,LName varchar(15) ,email varchar(30),pass_word varchar(30),out response varchar(100))
BEGIN
    declare t integer;
    if (select count(*) from UserDetails where UserDetails.Email=email)!=0 THEN
        set response:="Email already exists";
        select response as 'response';
    
    else 
        insert into UserDetails(UserName,FName,LName,Email,Pass,online_status)
        values(UserName,FName,LName,email,pass_word,"0");
        select UID into t from UserDetails where UserDetails.Email=email;
        INSERT into Albums values(null,t,"ProfilePhotos");
        INSERT into Albums values(null,t,"CoverPhotos");
        INSERT into Albums values(null,t,"MobileUploads");
        set response:="UR SIGNED UP!";
        select response as 'response';
    end if;
    end;
#

create procedure add_photos(in album_name varchar(30),in email varchar(30),in pic blob,out response varchar(100))
BEGIN
    declare u_id INTEGER;
    declare a_id INTEGER;
    select UID into u_id from UserDetails where UserDetails.Email =email;
    select AID into a_id from Albums where Albums.UID=u_id and Albums.Aname=album_name;
    insert into Gallery values(null,a_id,pic);
    
    set response:="Photo Added !";
    select response as 'response';
END;
#


create procedure send_message(in from_email varchar(30), in to_email varchar(30),in msg varchar(1000),out response varchar (100))
BEGIN
    
    declare sender VARCHAR(30);
    declare receiver VARCHAR(30);
    select UID into sender from UserDetails where Email=from_email;
    select UID into receiver from UserDetails where Email=to_email;


    if (SELECT count(*) from Friends where Friends.ToUID= receiver and Friends.FromUID=sender or Friends.ToUID=sender and Friends.FromUID=receiver) !=0 THEN
         
        INSERT into Messages(ToUID,FromUID,Msg) values (sender,receiver,msg);
        set response:="Message sent";
        select response as 'response';
    end IF;
END;

#


create procedure sign_in(in EmailID varchar(30), in PassW varchar(30), out response varchar(100) )
BEGIN
    if (select count(*) from UserDetails where UserDetails.Email=EmailID and UserDetails.Pass=PassW) !=0 THEN
        update UserDetails set online_status="Online" where UserDetails.Email=emailID;
        set response:="Succesful";
        select response as 'response';
    else 
        set response:="Invalid Email Id/Password";
        select response as 'response';

        end IF;
    end;
#




create procedure create_friendship(in sender varchar(30),in receiver varchar(30),out response varchar(100))
BEGIN
    declare sender1 VARCHAR(30);
    declare receiver1 VARCHAR(30);
    select UID into sender1 from UserDetails where Email=sender;
    select UID into receiver1 from UserDetails where Email=receiver;

    if (SELECT count(*) from Friends where Friends.ToUID= receiver1 and Friends.FromUID=sender1 or Friends.ToUID=sender1 and Friends.FromUID=receiver1) !=0 THEN
        set response:="You are already friends";
        select response as 'response';

    else 
        insert into Friends(ToUID,FromUID) values(sender1,receiver1);
        set response:="You are Friends now!";
        select response as 'response';
    end if;
    end;
#

create procedure send_request(in sender1 varchar(30),in receiver1 varchar(30),out response varchar(100))
BEGIN
    declare sender2 Int(10);
    declare receiver2 Int(10);
    select UID into sender2 from UserDetails where Email=sender1;
    select UID into receiver2 from UserDetails where Email=receiver1;

    if (SELECT count(*) from Friends where Friends.ToUID= receiver2 and Friends.FromUID=sender2 or Friends.ToUID=sender2 and Friends.FromUID=receiver2) !=0 THEN
        set response:="You are already friends";
        select response as 'response';
        
    
    elseif (select count(*) from FriendRequests where FriendRequests.sender=sender2 and FriendRequests.receiver=receiver2)!=0 Then
        set response:="You have already sent a request";
        select response as 'response';

    ELSE
        insert into FriendRequests(sender,receiver) values(sender2,receiver2);
        set response:="Request Sent";
        select response as 'response';

    end IF;
    end;
#

create PROCEDURE check_online(in email varchar(30),out response VARCHAR(30))
BEGIN
    DECLARE t varchar(30);
    select UserName into t from UserDetails where UserDetails.Email=email;
    if (SELECT online_status from UserDetails where UserDetails.Email=email) = "Online" THEN
        set response:= concat(t," is online");
        select response as 'response';
    end if;
end;
#

create PROCEDURE accept_request(in sender1 varchar(30),in receiver1 varchar(30), out response varchar(100))
BEGIN
    declare sender2 Int(10);
    declare receiver2 Int(10);
    declare op VARCHAR(30);
    DECLARE t varchar(30);
    select UserName into t from UserDetails where UserDetails.Email=sender1;
    select UID into sender2 from UserDetails where Email=sender1;
    select UID into receiver2 from UserDetails where Email=receiver1;
    if (select count(*) from FriendRequests where FriendRequests.sender=sender2 and FriendRequests.receiver=receiver2)!=0 Then
        call create_friendship(sender1,receiver1,op);
        delete from FriendRequests where sender=sender2 and receiver=receiver2;
        set response:= CONCAT("You have Accepted the requested of ",t);
        select response as 'response' ;
    end IF;    
END;
#

create PROCEDURE cancel_request(in sender1 varchar(30), in receiver1 varchar(30), out response varchar(100))
    BEGIN
        DECLARE t varchar(30);
        declare sender2 Int(10);
        declare receiver2 Int(10);
        select UserName into t from UserDetails where UserDetails.Email=receiver1;
        select UID into sender2 from UserDetails where Email=sender1;
        select UID into receiver2 from UserDetails where Email=receiver1;
        delete from FriendRequests where sender=sender2 and receiver=receiver2;
        set response:= CONCAT("You have deleted the requested to ",t);
        select response as 'response' ;
    END;
#

create PROCEDURE decline_request(in sender1 varchar(30), in receiver1 varchar(30), out response varchar(100))
    BEGIN
        DECLARE t varchar(30);
        declare sender2 Int(10);
        declare receiver2 Int(10);
        select UID into sender2 from UserDetails where Email=sender1;
        select UID into receiver2 from UserDetails where Email=receiver1;
        select UserName into t from UserDetails where UserDetails.Email=sender1;
        delete from FriendRequests where sender=sender2 and receiver=receiver2;
        set response:= concat("You have declined the requested of " ,t);
        select response as 'response' ;
    END;
#

create PROCEDURE search(in searchName varchar(30))
    BEGIN
        SELECT UserName from UserDetails where UserDetails.UserName like CONCAT("%",searchName,"%");
    END;
#

CREATE PROCEDURE check_received_friend_requests(in emailId varchar(30))
    BEGIN
        DECLARE t int(10);
        select UID into t from UserDetails where Email=emailId;
        SELECT UserName from UserDetails,FriendRequests where FriendRequests.receiver= t and UserDetails.UID=sender;
    END;
#
CREATE PROCEDURE home(in emailID varchar(30))
    BEGIN
        DECLARE t int(10);
        select UID into t from UserDetails where Email=emailId;
        select Img, Tweet,NumLikes,NumComments from Posts cross join Friends where Friends.ToUID=t; 
    end;
    #
-- CREATE PROCEDURE home_test(in emailID varhar(30))
--     BEGIN
--         DECLARE t int(10);
--         select UID into t from UserDetails where Email=emailId;
--         select Img, Tweet,NumLikes,NumComments from Posts cross join Friends where Friends.FromUID=t or Friends.ToUID=t; 
--     END;
-- #
CREATE PROCEDURE check_sent_friend_requests(in emailId varchar(30))
    BEGIN
        DECLARE t int(10);
        select UID into t from UserDetails where Email=emailId;
        SELECT UserName from UserDetails,FriendRequests where FriendRequests.sender= t and UserDetails.UID=receiver;
    END;
#
delimiter ;

source execution.sql;



-- insert into Album values(1,1,"profile_photos");




