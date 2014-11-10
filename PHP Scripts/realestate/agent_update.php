<?php 

  require_once 'header.php';
  $controller = new ControllerAgent();
  $controllerUser = new ControllerUser();

  $users = $controllerUser->getUsers();

  $extras = new Extras();
  $agent_id = $extras->decryptQuery1(KEY_SALT, $_SERVER['QUERY_STRING']);

  if($agent_id != null) {
        $agent = $controller->getAgentByAgentId($agent_id);
        
        if( isset($_POST['submit']) ) {
    
          $itm = new Agent();
          $itm->address = trim(strip_tags($_POST['address']));
          $itm->contact_no = trim(strip_tags($_POST['contact_no']));
          $itm->country = trim(strip_tags($_POST['country']));
          $itm->created_at = time();
          $itm->email = trim(strip_tags($_POST['email']));
          $itm->name = trim(strip_tags($_POST['name']));
          $itm->sms = trim(strip_tags($_POST['sms']));
          $itm->updated_at = time();
          $itm->zipcode = trim(strip_tags($_POST['zipcode']));
          $itm->photo_url = trim(strip_tags($_POST['photo_url']));
          $itm->thumb_url = trim(strip_tags($_POST['thumb_url']));

          $itm->twitter = trim(strip_tags($_POST['twitter']));
          $itm->fb = trim(strip_tags($_POST['fb']));
          $itm->linkedin = trim(strip_tags($_POST['linkedin']));
          $itm->company = trim(strip_tags($_POST['company']));
          $itm->user_id = trim(strip_tags($_POST['user_id']));
          $itm->agent_id = $agent_id;
          
          $count = count($_FILES["file"]["name"]);

          if( !empty($_FILES["file"]["name"][0]) && !empty($_FILES["file"]["name"][1]) ) {
              uploadFile($controller, $itm);
          }
          else {

              $controller->updateAgent($itm);
              echo "<script type='text/javascript'>location.href='agents.php';</script>";
          }
        }
  }
  else {
        echo "<script type='text/javascript'>location.href='403.php';</script>";
  }

  
  


  function uploadFile($controller, $itm) {

      $extras = new Extras();
      
      $desired_dir = IMAGE_UPLOAD_DIR;
      $errors= array();
      $count=count($_FILES["file"]["name"]);

      for($key = 0; $key < $count; $key++){

          $file_name = $_FILES['file']['name'][$key];
          $file_size = $_FILES['file']['size'][$key];
          $file_tmp = $_FILES['file']['tmp_name'][$key];
          $file_type= $_FILES['file']['type'][$key];

          if($file_size > 2097152){
              $errors[]='File size must be less than 2 MB';
          }    

          $date = date_create();
          $timestamp =  time();
          $temp = explode(".", $_FILES["file"]["name"][0]);
          $extension = end($temp);


          $new_file_name = $desired_dir."/"."large_".$timestamp.".".$extension;

          if($key == 1)
            $new_file_name = $desired_dir."/"."thumb_".$timestamp.".".$extension;

          if(empty($errors)==true){
            if(is_dir($desired_dir)==false){
                // Create directory if it does not exist
                mkdir("$desired_dir", 0700);        
            }
            if(is_dir($file_name)==false){
                // rename the file if another one exist
                move_uploaded_file($file_tmp, $new_file_name);
            }else{                                  
                $new_dir = $new_file_name.time();
                rename($file_tmp, $new_dir) ;               
            }

            if($key == 0) {
                $itm->photo_url = ROOT_URL.$new_file_name;
            }

            if($key == 1) {
                $itm->thumb_url = ROOT_URL.$new_file_name;
            }

          }else{
              print_r($errors);
          }
      }

      $controller->updateAgent($itm);
      echo "<script type='text/javascript'>location.href='agents.php';</script>";
  }

?>


<!DOCTYPE html>
<html lang="en"><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="shortcut icon" href="http://getbootstrap.com/assets/ico/favicon.ico">

    <title>RealEstate Finder</title>

    <!-- Bootstrap core CSS -->
    <link href="bootstrap/css/bootstrap.css" rel="stylesheet">
    <!-- Custom styles for this template -->
    <link href="bootstrap/css/navbar-fixed-top.css" rel="stylesheet">
    <link href="bootstrap/css/custom.css" rel="stylesheet">

    <!-- Just for debugging purposes. Don't actually copy this line! -->
    <!--[if lt IE 9]><script src="../../assets/js/ie8-responsive-file-warning.js"></script><![endif]-->

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>

  <body>

    <!-- Fixed navbar -->
    <div class="navbar navbar-default navbar-fixed-top" role="navigation">
      <div class="container">


        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">RealEstate Finder</a>
        </div>


        <div class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <li ><a href="home.php">Home</a></li>
            <li ><a href="propertytypes.php">Property Type</a></li>
            <li ><a href="realestates.php">Real Estates</a></li>
            <li class="active"><a href="agents.php">Agents</a></li>
            <li ><a href="admin_access.php">Admin Access</a></li>
            <li ><a href="users.php">Users</a></li>
          </ul>
          
          <ul class="nav navbar-nav navbar-right">
            <li ><a href="index.php">Logout</a></li>
          </ul>
        </div><!--/.nav-collapse -->
        
      </div>
    </div>

    <div class="container">

      <!-- Example row of columns -->
      <div class="panel panel-default">
        <div class="panel-heading">
          <h3 class="panel-title">Update Agent</h3>
        </div>

        <form action="" method="POST" enctype="multipart/form-data">
        <div class="panel-body">
              <div class="row">
                <div class="col-md-7">

                  

                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Agent Name" name="name" required value="<?php echo $agent->name; ?>">
                      </div>

                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Address" name="address" required value="<?php echo $agent->address; ?>">
                      </div>

                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Contact No" name="contact_no" required value="<?php echo $agent->contact_no; ?>">
                      </div>

                       <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Country" name="country" required value="<?php echo $agent->country; ?>">
                      </div>

                       <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="SMS No" name="sms" required value="<?php echo $agent->sms; ?>">
                      </div>

                       <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Zip Code" name="zipcode" required value="<?php echo $agent->zipcode; ?>">
                      </div>

                       <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Twitter" name="twitter" required value="<?php echo $agent->twitter; ?>">
                      </div>

                       <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Facebook" name="fb" required value="<?php echo $agent->fb; ?>">
                      </div>

                       <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Linked In" name="linkedin" required value="<?php echo $agent->linkedin; ?>">
                      </div>

                       <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Company" name="company" required value="<?php echo $agent->company; ?>">
                      </div>

                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Email" name="email" required value="<?php echo $agent->email; ?>">
                      </div>

                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Photo URL" name="photo_url" required value="<?php echo $agent->photo_url; ?>">
                      </div>

                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Thumb URL" name="thumb_url" required value="<?php echo $agent->thumb_url; ?>">
                      </div>

                      <br />
                      <div class="input-group" style="width:100%;">
                        <select class="form-control" style="width:100%;" name="user_id">
                          <option value="None">Assigned to User</option>
                          <?php
                              if($users != null) {

                                  echo "<option value='-1'>No User</option>";
                                  foreach ($users as $user)  {

                                        $selected = "";

                                        if($user->user_id == $agent->user_id)
                                            $selected = "selected";

                                        echo "<option value='$user->user_id' $selected>$user->full_name</option>";
                                  }
                              }
                          ?>
                          
                        </select>
                      </div>
                  


                </div>
                <div class="col-md-5">

                  <h4>Instead of URL, upload via File</h4>
                  

                    <div class="input-group">
                      <p>Photo File</p>
                      <input type="file" name="file[]" />
                    </div>

                    <br /> 
                    <div class="input-group">
                      <p>Thumbnail File</p>
                      <input type="file" name="file[]" />
                    </div>


                    <br /> 
                      <p>
                          <button type="submit" name="submit" class="btn btn-info"  role="button">Save</button> 
                          <a class="btn btn-info" href="agents.php" role="button">Cancel</a>
                      </p>

                  

               </div>
        </div>
        </form><!--/.form -->
      </div>


    </div> <!-- /container -->


    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="bootstrap/js/jquery.js"></script>
    <script src="bootstrap/js/bootstrap.js"></script>
    
  

</body></html>