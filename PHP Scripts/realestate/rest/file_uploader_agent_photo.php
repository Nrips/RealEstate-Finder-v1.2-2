<?php
    
    require_once '../header_rest.php';
    $controllerAgent = new ControllerAgent();
    $controllerUser = new ControllerUser();

    if( !empty($_POST['user_id']) )
        $user_id = $_POST['user_id'];

    if( !empty($_POST['login_hash']) )
        $login_hash = $_POST['login_hash'];

    $agent_id = 0;
    if( !empty($_POST['agent_id']) )
        $agent_id = $_POST['agent_id'];


    $photo_url = "";
    if( !empty($_POST['photo_url']) )
        $photo_url = trim(strip_tags($_POST['photo_url']));

    $thumb_url = "";
    if( !empty($_POST['thumb_url']) )
        $thumb_url = trim(strip_tags($_POST['thumb_url']));

    if( !empty($agent_id) && !empty($login_hash) && !empty($user_id) ) {
          
        $user = $controllerUser->getUserByUserId($user_id);

        $login_hash = str_replace(" ", "+", $login_hash);
        if($user != null) {
            
            if($user->login_hash == $login_hash) {

                $itm = new Agent();
                $itm->photo_url = $photo_url;
                $itm->thumb_url = $thumb_url;
                $itm->agent_id = $agent_id;

                
                if( !empty($_FILES["thumb_file"]["name"]) && !empty($_FILES["photo_file"]["name"]) ) {

                    $desired_dir = IMAGE_UPLOAD_DIR;
                    $desired_dir_path = "../".IMAGE_UPLOAD_DIR;

                    if(is_dir($desired_dir_path)==false) {
                        // Create directory if it does not exist
                        mkdir("$desired_dir_path", 0700);        
                    }

                    $id =  uniqid();
                    $temp = explode(".", $_FILES["thumb_file"]["name"]);
                    $extension = end($temp);
                    $thumb_new_file_name = $desired_dir."/"."thumb_".$id.".".$extension;
                    $thumb_new_file_name_path = $desired_dir_path."/"."thumb_".$id.".".$extension;
                    move_uploaded_file($_FILES['thumb_file']['tmp_name'], $thumb_new_file_name_path);
                    $itm->thumb_url = ROOT_URL.$thumb_new_file_name;


                    $id =  uniqid();
                    $temp = explode(".", $_FILES["photo_file"]["name"]);
                    $extension = end($temp);
                    $photo_new_file_name = $desired_dir."/"."photo_".$id.".".$extension;
                    $photo_new_file_name_path = $desired_dir_path."/"."photo_".$id.".".$extension;
                    move_uploaded_file($_FILES['photo_file']['tmp_name'], $photo_new_file_name_path);
                    $itm->photo_url = ROOT_URL.$photo_new_file_name;


                    $controllerAgent->updateAgentPhotos($itm);
                    $itm = $controllerAgent->getAgentByUserId($user_id);

                    $json = "{
                            \"photo_agent_info\" : {
                                          \"agent_id\" : \"$itm->agent_id\",
                                          \"photo_url\" : \"$itm->photo_url\",
                                          \"thumb_url\" : \"$itm->thumb_url\"
                                          },
                            \"status\" : {
                                          \"status_code\" : \"-1\",
                                          \"status_text\" : \"Success.\"
                                        }
                            }";

                }
                else {

                    $controllerAgent->updateAgentPhotos($itm);
                    $itm = $controllerAgent->getAgentByUserId($user_id);

                    $json = "{
                            \"photo_agent_info\" : {
                                          \"agent_id\" : \"$itm->agent_id\",
                                          \"photo_url\" : \"$itm->photo_url\",
                                          \"thumb_url\" : \"$itm->thumb_url\"
                                          },
                            \"status\" : {
                                          \"status_code\" : \"-1\",
                                          \"status_text\" : \"Success.\"
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