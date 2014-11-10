<?php

    require_once '../header_rest.php';
    
    $controllerRestAgent = new ControllerAgent();
    $controllerUser = new ControllerUser();

    $user_id ="";
    if( !empty($_POST['user_id']) )
        $user_id = $_POST['user_id'];

    $login_hash ="";
    if( !empty($_POST['login_hash']) )
        $login_hash = $_POST['login_hash'];

    $address ="";
    if( !empty($_POST['address']) )
        $address = trim(strip_tags($_POST['address']));

    $contact_no ="";
    if( !empty($_POST['contact_no']) )
        $contact_no = trim(strip_tags($_POST['contact_no']));

    $country ="";
    if( !empty($_POST['country']) )
        $country = trim(strip_tags($_POST['country']));

    $email ="";
    if( !empty($_POST['email']) )
        $email = $_POST['email'];

    $name ="";
    if( !empty($_POST['name']) )
        $name = $_POST['name'];

    $sms ="";
    if( !empty($_POST['sms']) )
        $sms = trim(strip_tags($_POST['sms']));

    $zipcode ="";
    if( !empty($_POST['zipcode']) )
        $zipcode = trim(strip_tags($_POST['zipcode']));

    $twitter ="";
    if( !empty($_POST['twitter']) )
        $twitter = trim(strip_tags($_POST['twitter']));

    $fb ="";
    if( !empty($_POST['fb']) )
        $fb = trim(strip_tags($_POST['fb']));

    $linkedin ="";
    if( !empty($_POST['linkedin']) )
        $linkedin = trim(strip_tags($_POST['linkedin']));

    $company ="";
    if( !empty($_POST['company']) )
        $company = trim(strip_tags($_POST['company']));


    $created_at = time();
    $updated_at = time();

    $photo_url = "";
    $thumb_url = "";

    if( !empty($name) && !empty($contact_no) && !empty($email) && 
        !empty($sms) && !empty($address) && !empty($login_hash) && !empty($user_id) ) {
          
        $user = $controllerUser->getUserByUserId($user_id);

        $login_hash = str_replace(" ", "+", $login_hash);
        if($user != null) {
            
            if($user->login_hash == $login_hash) {

                $agent = $controllerRestAgent->getAgentByUserId($user_id);

                $itm = new Agent();
                $itm->address = $address;
                $itm->contact_no = $contact_no;
                $itm->country = $country;
                $itm->created_at = $created_at;
                $itm->email = $email;
                $itm->name = $name;
                $itm->sms = $sms;
                $itm->updated_at = $updated_at;
                $itm->zipcode = $zipcode;
                $itm->photo_url = $photo_url;
                $itm->thumb_url = $thumb_url;
                $itm->twitter = $twitter;
                $itm->fb = $fb;
                $itm->linkedin = $linkedin;
                $itm->company = $company;
                $itm->user_id = $user_id;


                if($agent != null) {
                    $itm->agent_id = $agent->agent_id;
                    $controllerRestAgent->updateAgent($itm);
                }
                else {
                    $controllerRestAgent->insertAgent($itm);
                }

                $itm = $controllerRestAgent->getAgentByUserId($user_id);

                $json = "{
                          \"agent_info\" : {
                                        \"address\" : \"$itm->address\",
                                        \"agent_id\" : \"$itm->agent_id\",
                                        \"contact_no\" : \"$itm->contact_no\",
                                        \"country\" : \"$itm->country\",
                                        \"created_at\" : \"$itm->created_at\",
                                        \"email\" : \"$itm->email\",
                                        \"name\" : \"$itm->name\",
                                        \"sms\" : \"$itm->sms\",
                                        \"updated_at\" : \"$itm->updated_at\",
                                        \"zipcode\" : \"$itm->zipcode\",
                                        \"photo_url\" : \"$itm->photo_url\",
                                        \"thumb_url\" : \"$itm->thumb_url\",
                                        \"twitter\" : \"$itm->twitter\",
                                        \"fb\" : \"$itm->fb\",
                                        \"linkedin\" : \"$itm->linkedin\",
                                        \"company\" : \"$itm->company\",
                                        \"user_id\" : \"$user->user_id\",
                                        },

                          \"status\" : {
                                        \"status_code\" : \"-1\",
                                        \"status_text\" : \"Success.\"
                                      }
                        }";
            }
            else {

                $json = "{
                        \"status\" : {
                                      \"status_code\" : \"5\",
                                      \"status_text\" : \"It seems you are out of sync. Please relogin again.\"
                                    }
                        }";
            }
        }
        else {
            $json = "{
                          \"status\" : {
                                        \"status_code\" : \"5\",
                                        \"status_text\" : \"It seems you are out of sync. Please relogin again.\"
                                      }
                          }";
        }
        
    }
    else {

        $json = "{
                  \"status\" : {
                                \"status_code\" : \"3\",
                                \"status_text\" : \"Invalid Access.\"
                              }
                  }";

        
    }

    echo $json;

?>