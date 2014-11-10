<?php 

  require_once 'header.php';
  $controller = new ControllerAgent();
  $agents = $controller->getAgents();

  if(!empty($_SERVER['QUERY_STRING'])) {

      $extras = new Extras();
      $agent_id = $extras->decryptQuery1(KEY_SALT, $_SERVER['QUERY_STRING']);
      if( $agent_id != null ) {
          $controller->deleteAgent($agent_id, 1);
          echo "<script type='text/javascript'>location.href='agents.php';</script>";
      }
      else {
        echo "<script type='text/javascript'>location.href='403.php';</script>";
      }
  }
  

  $search_criteria = "";
  if( isset($_POST['button_search']) ) {
      $search_criteria = trim(strip_tags($_POST['search']));
      $agents = $controller->getAgentsBySearching($search_criteria);
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

      <div class="panel panel-default">
        <!-- Default panel contents -->
        <div class="panel-heading clearfix">
          <h4 class="panel-title pull-left" style="padding-top: 7px;">Agents</h4>
          <div class="btn-group pull-right">
            <!-- <a href="seller_insert.php" class="btn btn-default btn-sm">Add Seller</a> -->
            <form method="POST" action="">
                  <input type="text" style="height:100%;color:#000000;padding-left:5px;" placeholder="Search" name="search" value="<?php echo $search_criteria; ?>">
                  <button type="submit" name="button_search" class="btn btn-default btn-sm"><span class="glyphicon glyphicon-search"></span></button>
                  <button type="submit" class="btn btn-default btn-sm" name="reset"><span class="glyphicon glyphicon-refresh"></span></button>
                  <a href="agent_insert.php" class="btn btn-default btn-sm"><span class='glyphicon glyphicon-plus'></span></a>
            </form>
          </div>
        </div>

        <!-- Table -->
        <table class="table">
          <thead>
              <tr>
                  <th>#</th>
                  <th>Name</th>
                  <th>Address</th>
                  <th>Contact No</th>
                  <th>Photos</th>
                  <th>Action</th>
              </tr>

          </thead>
          <tbody>
              <?php 

                  if($agents != null) {

                    $ind = 1;
                    foreach ($agents as $agent)  {

                          $extras = new Extras();
                          $updateUrl = $extras->encryptQuery1(KEY_SALT, 'agent_id', $agent->agent_id, 'agent_update.php');
                          $deleteUrl = $extras->encryptQuery1(KEY_SALT, 'agent_id', $agent->agent_id, 'agents.php');

                          echo "<tr>";
                          echo "<td>$ind</td>";
                          echo "<td>$agent->name</td>";
                          echo "<td>$agent->address</td>";

                          echo "<td>
                                      <button class='btn btn-primary btn-xs' data-toggle='modal' data-target='#modal_photo_thumb_$agent->agent_id'>Thumb</button>
                                      <button class='btn btn-primary btn-xs' data-toggle='modal' data-target='#modal_photo_large_$agent->agent_id'>Large</button>
                                </td>";
                          echo "<td>$agent->contact_no</td>";
                          echo "<td>
                                    <a class='btn btn-primary btn-xs' href=\"$updateUrl\"><span class='glyphicon glyphicon-pencil'></span></a>
                                    <button class='btn btn-primary btn-xs' data-toggle='modal' data-target='#modal_$agent->agent_id'><span class='glyphicon glyphicon-remove'></span></button>
                                </td>";
                          echo "</tr>";

                          echo "<div class='modal fade' id='modal_$agent->agent_id' tabindex='-1' role='dialog' aria-labelledby='myModalLabel' aria-hidden='true'>

                                      <div class='modal-dialog'>
                                          <div class='modal-content'>
                                              <div class='modal-header'>
                                                    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>
                                                    <h4 class='modal-title' id='myModalLabel'>Deleting Agent</h4>
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


                          //<!-- Modal -->
                          echo "<div class='modal fade' id='modal_photo_thumb_$agent->agent_id' tabindex='-1' role='dialog' aria-labelledby='myModalLabel' aria-hidden='true'>";
                              echo "<div class='modal-dialog'>";
                                  echo "<div class='modal-content'>";
                                      echo "<div class='modal-header'>";
                                          echo "<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>";
                                          echo "<h4 class='modal-title' id='myModalLabel'>Thumbnail Photo</h4>";
                                      echo "</div>";

                                      echo "<div class='modal-body'>";
                                          echo "<img src='$agent->thumb_url' style = 'display:block; height:100%; margin-left:auto; margin-right:auto; max-width:100%;'/>";
                                      echo "</div>";
                                    
                                  echo "</div>";
                              echo "</div>";
                          echo "</div>";

                          //<!-- Modal -->
                          echo "<div class='modal fade' id='modal_photo_large_$agent->agent_id' tabindex='-1' role='dialog' aria-labelledby='myModalLabel' aria-hidden='true'>";
                              echo "<div class='modal-dialog'>";
                                  echo "<div class='modal-content'>";
                                      echo "<div class='modal-header'>";
                                          echo "<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>";
                                          echo "<h4 class='modal-title' id='myModalLabel'>Large Photo</h4>";
                                      echo "</div>";

                                      echo "<div class='modal-body'>";
                                          echo "<img src='$agent->photo_url' style = 'display:block; height:100%; margin-left:auto; margin-right:auto; max-width:100%;'/>";
                                      echo "</div>";
                                    
                                  echo "</div>";
                              echo "</div>";
                          echo "</div>";



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