<?php 

  require_once 'header.php';
  $controller = new ControllerRealEstate();
  $controllerPhoto = new ControllerPhoto();
  $realestates = $controller->getRealEstates();

  if(!empty($_SERVER['QUERY_STRING'])) {

      $extras = new Extras();
      $realestate_id = $extras->decryptQuery1(KEY_SALT, $_SERVER['QUERY_STRING']);
      $realestate_id_featured = $extras->decryptQuery2(KEY_SALT, $_SERVER['QUERY_STRING']);

      if( $realestate_id != null ) {
          $controller->deleteRealEstate($realestate_id, 1);
          echo "<script type='text/javascript'>location.href='realestates.php';</script>";
      }
      
      
      if($realestate_id_featured != null) {
          $itm = new RealEstate();
          $itm->realestate_id = $realestate_id_featured[0];
          $itm->featured = $realestate_id_featured[1] == "yes" ? 0 : 1;
          
          $res = $controller->updateRealEstateFeatured($itm);

          
          echo "<script type='text/javascript'>location.href='realestates.php';</script>";
      }

      if($realestate_id_featured == null && $realestate_id == null) {
        echo "<script type='text/javascript'>location.href='403.php';</script>";
      }
  }

  $search_criteria = "";
  if( isset($_POST['button_search']) ) {
      $search_criteria = trim(strip_tags($_POST['search']));
      $realestates = $controller->getRealEstatesBySearching($search_criteria);
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
            <li class="active"><a href="realestates.php">Real Estates</a></li>
            <li ><a href="agents.php">Agents</a></li>
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

      <div class="panel panel-default">
        <!-- Default panel contents -->
        <div class="panel-heading clearfix">
          <h4 class="panel-title pull-left" style="padding-top: 7px;">Real Estates</h4>
          <div class="btn-group pull-right">
            <!-- <a href="car_insert.php" class="btn btn-default btn-sm">Add Car</a> -->
            <form method="POST" action="">
                  <input type="text" style="height:100%;color:#000000;padding-left:5px;" placeholder="Search" name="search" value="<?php echo $search_criteria; ?>">
                  <button type="submit" name="button_search" class="btn btn-default btn-sm"><span class="glyphicon glyphicon-search"></span></button>
                  <button type="submit" class="btn btn-default btn-sm" name="reset"><span class="glyphicon glyphicon-refresh"></span></button>
                  <a href="realestate_insert.php" class="btn btn-default btn-sm"><span class='glyphicon glyphicon-plus'></span></a>
            </form>
          </div>
        </div>

        <!-- Table -->
        <table class="table">
          <thead>
              <tr>
                  <th>ID</th>
                  <th>Price</th>
                  <th>Address</th>
                  <th>No of Photos</th>
                  <th>is Featured?</th>
                  <th>Action</th>
              </tr>

          </thead>
          <tbody>
              <?php 

                  if($realestates != null) {

                    $ind = 1;
                    foreach ($realestates as $realestate)  {
                      
                          $featured = "no";
                          if($realestate->featured == 1)
                              $featured = "yes";

                          $no_of_photos = $controllerPhoto->getNoOfPhotosByRealEstateId($realestate->realestate_id);

                          $extras = new Extras();
                          $updateUrl = $extras->encryptQuery1(KEY_SALT, 'realestate_id', $realestate->realestate_id, 'realestate_update.php');
                          $deleteUrl = $extras->encryptQuery1(KEY_SALT, 'realestate_id', $realestate->realestate_id, 'realestates.php');
                          $featuredUrl = $extras->encryptQuery2(KEY_SALT, 'realestate_id', $realestate->realestate_id, 'featured', $featured, 'realestates.php');
                          $viewUrl = $extras->encryptQuery1(KEY_SALT, 'realestate_id', $realestate->realestate_id, 'photo_realestate_view.php');
                          $photoUrl = $extras->encryptQuery1(KEY_SALT, 'realestate_id', $realestate->realestate_id, 'photo_realestate_insert.php');

                          echo "<tr>";
                          echo "<td>$realestate->realestate_id</td>";
                          echo "<td>$realestate->price</td>";
                          echo "<td>$realestate->address</td>";
                          echo "<td>$no_of_photos Photo(s)</td>";
                          
                          if($realestate->featured == 1) {
                            echo "<td><a href='$featuredUrl'>No</a></td>";
                          }
                          else {
                            echo "<td><a href='$featuredUrl'>Yes</a></td>";
                          }


                          echo "<td>
                                    <a class='btn btn-primary btn-xs' href='$updateUrl'><span class='glyphicon glyphicon-pencil'></span></a>
                                    <button  class='btn btn-primary btn-xs' data-toggle='modal' data-target='#modal_$realestate->realestate_id'><span class='glyphicon glyphicon-remove'></span></button>
                                    <a class='btn btn-primary btn-xs' href='$viewUrl'><span class='glyphicon glyphicon-th'></span></a>
                                    
                                </td>";
                          echo "</tr>";


                          //<!-- Modal -->
                          echo "<div class='modal fade' id='modal_$realestate->realestate_id' tabindex='-1' role='dialog' aria-labelledby='myModalLabel' aria-hidden='true'>

                                      <div class='modal-dialog'>
                                          <div class='modal-content'>
                                              <div class='modal-header'>
                                                    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>
                                                    <h4 class='modal-title' id='myModalLabel'>Deleting Real Estate</h4>
                                              </div>
                                              <div class='modal-body'>
                                                    <p>Deleting this is not irreversible. Do you wish to continue?
                                              </div>
                                              <div class='modal-footer'>
                                                  <button type='button' class='btn btn-default' data-dismiss='modal'>Close</button>
                                                  <a type='button' class='btn btn-primary' href='$deleteUrl'>Delete</a>
                                              </div>
                                          </div>
                                      </div>
                                </div>";

                          ++$ind;
                    }
                  }

              ?>

          </tbody>
          
        </table>
      </div>


    </div> <!-- /container -->


    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="bootstrap/js/jquery.js"></script>
    <script src="bootstrap/js/bootstrap.js"></script>
    
  

</body></html>