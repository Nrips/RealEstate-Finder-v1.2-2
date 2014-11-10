<?php

    require_once '../header_rest.php';
    
    $controllerPhoto = new ControllerPhoto();
    $controllerUser = new ControllerUser();

    if( !empty($_POST['user_id']) )
        $user_id = $_POST['user_id'];

    if( !empty($_POST['login_hash']) )
        $login_hash = $_POST['login_hash'];

    $realestate_id = 0;
    if( !empty($_POST['realestate_id']) )
        $realestate_id = $_POST['realestate_id'];

    $photo_id = 0;
    if( !empty($_POST['photo_id']) )
        $photo_id = $_POST['photo_id'];

    $photo_url = "";
    if( !empty($_POST['photo_url']) )
        $photo_url = trim(strip_tags($_POST['photo_url']));

    $thumb_url = "";
    if( !empty($_POST['thumb_url']) )
        $thumb_url = trim(strip_tags($_POST['thumb_url']));

    $is_deleted = 0;
    if( !empty($_POST['is_deleted']) )
        $is_deleted = $_POST['is_deleted'];

    if( !empty($realestate_id) && !empty($photo_id) > 0 && !empty($login_hash) && !empty($user_id) && $is_deleted == 1 ) {
        $user = $controllerUser->getUserByUserId($user_id);

        $login_hash = str_replace(" ", "+", $login_hash);
        if($user != null) {
            
            if($user->login_hash == $login_hash) {
                $controllerPhoto->deletePhoto($photo_id, 1);
                $json = "{
                    \"photo_realestate_info\" : {
                                  \"photo_id\" : \"$photo_id\",
                                  \"is_deleted\" : \"1\"
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
    else if( !empty($realestate_id) && !empty($photo_id) >= 0 && !empty($login_hash) && !empty($user_id) ) {
          
        $user = $controllerUser->getUserByUserId($user_id);

        $login_hash = str_replace(" ", "+", $login_hash);
        if($user != null) {
            
            if($user->login_hash == $login_hash) {

                $photo = $controllerPhoto->getPhotoByPhotoId($photo_id);

                $itm = new Photo();
                $itm->photo_id = $photo_id;
                $itm->photo_url = $photo_url;
                $itm->thumb_url = $thumb_url;
                $itm->created_at = time();
                $itm->updated_at = time();
                $itm->realestate_id = $realestate_id;

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



                    if($photo != null) {
                        $controllerPhoto->updatePhoto($itm);
                        $photo_id = $itm->photo_id;
                    }
                    else {
                        $controllerPhoto->insertPhoto($itm); 
                        $photo_id = $controllerPhoto->getLastInsertedPhotoId();
                    }

                    $itm = $controllerPhoto->getPhotoByPhotoId($photo_id);

                    $json = "{
                            \"photo_realestate_info\" : {
                                          \"photo_id\" : \"$itm->photo_id\",
                                          \"photo_url\" : \"$itm->photo_url\",
                                          \"thumb_url\" : \"$itm->thumb_url\",
                                          \"realestate_id\" : \"$itm->realestate_id\",
                                          \"created_at\" : \"$itm->created_at\",
                                          \"updated_at\" : \"$itm->updated_at\",
                                          \"is_deleted\" : \"0\"
                                          },
                            \"status\" : {
                                          \"status_code\" : \"-1\",
                                          \"status_text\" : \"Success.\"
                                        }
                            }";

                }
                else {
                    if($photo != null) {
                        $controllerPhoto->updatePhoto($itm);
                        $photo_id = $itm->photo_id;
                    }
                    else {
                        $controllerPhoto->insertPhoto($itm); 
                        $photo_id = $controllerPhoto->getLastInsertedPhotoId();
                    }

                    $itm = $controllerPhoto->getPhotoByPhotoId($photo_id);

                    $json = "{
                            \"photo_realestate_info\" : {
                                          \"photo_id\" : \"$itm->photo_id\",
                                          \"photo_url\" : \"$itm->photo_url\",
                                          \"thumb_url\" : \"$itm->thumb_url\",
                                          \"realestate_id\" : \"$itm->realestate_id\",
                                          \"created_at\" : \"$itm->created_at\",
                                          \"updated_at\" : \"$itm->updated_at\",
                                          \"is_deleted\" : \"0\"
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