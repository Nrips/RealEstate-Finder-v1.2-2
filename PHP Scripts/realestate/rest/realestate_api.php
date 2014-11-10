<?php

    require_once '../header_rest.php';
    $controllerRealEstate = new ControllerRealEstate();
    $controllerUser = new ControllerUser();

    if( !empty($_POST['login_hash']) )
        $login_hash = $_POST['login_hash'];

    if( !empty($_POST['user_id']) )
        $user_id = $_POST['user_id'];

    if( !empty($_POST['address']) )
        $address = $_POST['address'];

    if( !empty($_POST['agent_id']) )
        $agent_id = $_POST['agent_id'];

    $baths = "";
    if( !empty($_POST['baths']) )
        $baths = $_POST['baths'];

    $beds = "";
    if( !empty($_POST['beds']) )
        $beds = trim(strip_tags($_POST['beds']));

    $built_in = 0;
    if( !empty($_POST['built_in']) )
        $built_in = trim(strip_tags($_POST['built_in']));

    $country = "";
    if( !empty($_POST['country']) )
        $country = $_POST['country'];

    $desc1 = "";
    if( !empty($_POST['desc1']) )
        $desc1 = trim(strip_tags($_POST['desc1']));

    $featured = "";
    if( !empty($_POST['featured']) )
        $featured = trim(strip_tags($_POST['featured']));

    $lat = "";
    if( !empty($_POST['lat']) )
        $lat = trim(strip_tags($_POST['lat']));

    $lon = "";
    if( !empty($_POST['lon']) )
        $lon = trim(strip_tags($_POST['lon']));

    $lot_size = "";
    if( !empty($_POST['lot_size']) )
        $lot_size = trim(strip_tags($_POST['lot_size']));

    $price = "";
    if( !empty($_POST['price']) )
        $price = $_POST['price'];

    $price_per_sqft = "";
    if( !empty($_POST['price_per_sqft']) )
      $price_per_sqft = trim(strip_tags($_POST['price_per_sqft']));

    $property_type = "";
    if( !empty($_POST['property_type']) )
        $property_type = trim(strip_tags($_POST['property_type']));

    $realestate_id = 0;
    if( !empty($_POST['realestate_id']) )
        $realestate_id = trim(strip_tags($_POST['realestate_id']));

    $rooms = "";
    if( !empty($_POST['rooms']) )
        $rooms = trim(strip_tags($_POST['rooms']));

    $sqft = "";
    if( !empty($_POST['sqft']) )
        $sqft = trim(strip_tags($_POST['sqft']));

    $status = "";
    if( !empty($_POST['status']) )
        $status = trim(strip_tags($_POST['status']));

    $zipcode = "";
    if( !empty($_POST['zipcode']) )
        $zipcode = trim(strip_tags($_POST['zipcode']));

    $is_deleted = 0;
    if( !empty($_POST['is_deleted']) )
        $is_deleted = $_POST['is_deleted'];

    if( !empty($realestate_id) > 0 && !empty($login_hash) && !empty($user_id) && $is_deleted == 1 ) {
        
        $user = $controllerUser->getUserByUserId($user_id);
        $login_hash = str_replace(" ", "+", $login_hash);
        
        if($user != null) {
            
            if($user->login_hash == $login_hash) {
                $controllerRealEstate->deleteRealEstate($realestate_id, 1);
                $json = "{
                        \"realestate_info\" : {
                                        \"realestate_id\" : \"$realestate_id\",
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
    }

    else if( !empty($realestate_id) >= 0 && !empty($login_hash) && !empty($user_id) && !empty($agent_id) > 0 ) {
          
        $user = $controllerUser->getUserByUserId($user_id);

        $login_hash = str_replace(" ", "+", $login_hash);
        if($user != null) {
            
            if($user->login_hash == $login_hash) {


                $realestate = $controllerRealEstate->getRealEstateByRealEstateId($realestate_id);

                $itm = new RealEstate();
                $itm->address = $address;
                $itm->agent_id = $agent_id;
                $itm->baths = $baths;
                $itm->beds = $beds;
                $itm->built_in = $built_in;
                $itm->country = $country;
                $itm->created_at = time();
                $itm->desc1 = $desc1;
                $itm->featured = $featured;
                $itm->lat = $lat;
                $itm->lon = $lon;
                $itm->lot_size = $lot_size;
                $itm->price = $price;
                $itm->price_per_sqft = $price_per_sqft;
                $itm->property_type = $property_type;
                $itm->realestate_id = $realestate_id;
                $itm->rooms = $rooms;
                $itm->sqft = $sqft;
                $itm->status = $status;
                $itm->updated_at = time();
                $itm->zipcode = $zipcode;
                
                if($realestate != null) {
                    $itm->created_at = $realestate->created_at;
                    $itm->realestate_id = $realestate->realestate_id;
                    $controllerRealEstate->updateRealEstate($itm);
                }
                else {
                    $controllerRealEstate->insertRealEstate($itm);
                    $realestate_id = $controllerRealEstate->getLastInsertedId();
                }

                $itm = $controllerRealEstate->getRealEstateByRealEstateId( $realestate_id );

                $json = "{
                        \"realestate_info\" : {
                                      \"address\" : \"$itm->address\",
                                      \"agent_id\" : \"$itm->agent_id\",
                                      \"baths\" : \"$itm->baths\",
                                      \"beds\" : \"$itm->beds\",
                                      \"built_in\" : \"$itm->built_in\",
                                      \"country\" : \"$itm->country\",
                                      \"created_at\" : \"$itm->created_at\",
                                      \"desc1\" : \"$itm->desc1\",
                                      \"featured\" : \"$itm->featured\",
                                      \"lat\" : \"$itm->lat\",
                                      \"lon\" : \"$itm->lon\",
                                      \"is_deleted\" : \"0\",

                                      \"lot_size\" : \"$itm->lot_size\",
                                      \"price\" : \"$itm->price\",
                                      \"price_per_sqft\" : \"$itm->price_per_sqft\",
                                      \"property_type\" : \"$itm->property_type\",
                                      \"realestate_id\" : \"$itm->realestate_id\",
                                      \"rooms\" : \"$itm->rooms\",
                                      \"sqft\" : \"$itm->sqft\",
                                      \"status\" : \"$itm->status\",
                                      \"updated_at\" : \"$itm->updated_at\",
                                      \"zipcode\" : \"$itm->zipcode\"
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