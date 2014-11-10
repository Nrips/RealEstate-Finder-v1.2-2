<?php 

  require_once 'header.php';
  $controller = new ControllerRealEstate();
  $controllerAgent = new ControllerAgent();
  $controllerPropertyType = new ControllerPropertyType();

  $agents = $controllerAgent->getAgents();
  $propertytypes = $controllerPropertyType->getPropertyTypes();
  
  $extras = new Extras();
  if( isset($_POST['submit']) ) {
    
    $itm = new RealEstate();

    $itm->address = htmlspecialchars(trim(strip_tags($_POST['address'])), ENT_QUOTES);
    $itm->baths = htmlspecialchars(trim(strip_tags($_POST['baths'])), ENT_QUOTES);
    $itm->beds = trim(strip_tags($_POST['beds']));
    $itm->built_in = trim(strip_tags($_POST['built_in']));
    $itm->country = htmlspecialchars(trim(strip_tags($_POST['country'])), ENT_QUOTES);
    $itm->created_at = time();
    $itm->desc1 = $extras->removeHttp( htmlspecialchars(trim(strip_tags($_POST['desc1'])), ENT_QUOTES) );
    $itm->featured = htmlspecialchars(trim(strip_tags($_POST['featured'])), ENT_QUOTES);
    $itm->lat = trim(strip_tags($_POST['lat']));
    $itm->lon = trim(strip_tags($_POST['lon']));
    $itm->lot_size = trim(strip_tags($_POST['lot_size']));
    $itm->price = htmlspecialchars(trim(strip_tags($_POST['price'])), ENT_QUOTES);
    $itm->price_per_sqft = htmlspecialchars(trim(strip_tags($_POST['price_per_sqft'])), ENT_QUOTES);
    $itm->property_type = trim(strip_tags($_POST['property_type']));
    $itm->rooms = trim(strip_tags($_POST['rooms']));
    $itm->sqft = trim(strip_tags($_POST['sqft']));
    $itm->status = trim(strip_tags($_POST['status']));
    $itm->updated_at = time();
    $itm->is_deleted = 0;
    $itm->agent_id = trim(strip_tags($_POST['agent_id']));
    $itm->zipcode = trim(strip_tags($_POST['zipcode']));

    $controller->insertRealEstate($itm);
    echo "<script type='text/javascript'>location.href='realestates.php';</script>";

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

    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBB7Tce0Xd3GEb838FF5uRcIe8MQIRdQSo&sensor=false"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <script type="text/javascript" src="maps.plugin.js"></script>
    <script type="text/javascript">
        $(function(){
            var mapDiv = document.getElementById('map');
                var map = new google.maps.Map(mapDiv, {
                  center: new google.maps.LatLng(42.766727, -72.995293),
                  zoom: 10,
                  mapTypeId: google.maps.MapTypeId.ROADMAP,

                });

            var marker;
            google.maps.event.addListener(map, 'click', function (mouseEvent) {

                if(marker != null)
                  marker.setMap(null);

                var lat = document.getElementById('latitude');
                var longi = document.getElementById('longitude');
                lat.value = mouseEvent.latLng.lat(); //alert(mouseEvent.latLng.toUrlValue());
                longi.value = mouseEvent.latLng.lng();

                marker = new google.maps.Marker({
                    position: mouseEvent.latLng,
                    map: map,
                    title: 'Here!'
                });

            });

        });

        function validateLatLng(evt) {
            var theEvent = evt || window.event;
            var key = theEvent.keyCode || theEvent.which;
            key = String.fromCharCode( key );

            if(theEvent.keyCode == 8 || theEvent.keyCode == 127) {
                
            }
            else {
                var regex = /[0-9.]|\./;
                if( !regex.test(key) ) {
                  theEvent.returnValue = false;
                  if(theEvent.preventDefault) theEvent.preventDefault();
                }  
            }
        }
    </script>


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

      <!-- Example row of columns -->
      <div class="panel panel-default">
        <div class="panel-heading">
          <h3 class="panel-title">Add Real Estate</h3>
        </div>

        <div class="panel-body">
              <div class="row">
                <div class="col-md-7">

                  <form action="" method="POST">

                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Price" name="price" required>
                      </div>

                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Address" name="address" required>
                      </div>

                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Baths" name="baths" required>
                      </div>

                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Beds" required name="beds" id="website">
                      </div>

                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Built In" required name="built_in">
                      </div>

                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Country" required name="country">
                      </div>

                      <br />
                      <div class="input-group" style="width:100%;" >
                        <select class="form-control" style="width:100%;" name="featured">
                          <option value="-1">Select if Real Estate will be featured</option>
                          <option value="1">Real Estate Featured</option>
                          <option value="0">Real Estate Not Featured</option>
                        </select>
                      </div>

                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Lot Size" required name="lot_size">
                      </div>

                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Price/Sqft" required name="price_per_sqft">
                      </div>

                      <br />
                      <div class="input-group" style="width:100%;">
                        <select class="form-control" style="width:100%;" name="property_type">
                          <option value="None">Select Property Type</option>
                          <?php
                              if($propertytypes != null) {
                                  foreach ($propertytypes as $propertytype)  {
                                        echo "<option value='$propertytype->property_type'>$propertytype->property_type</option>";
                                  }
                              }
                          ?>
                          
                        </select>
                      </div>

                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Rooms" required name="rooms">
                      </div>

                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Sqft" required name="sqft">
                      </div>



                      <br />
                      <div class="input-group" style="width:100%;" >
                        <select class="form-control" style="width:100%;" name="status">
                          <option value="">Select Status</option>
                          <option value="For Sale">For Sale</option>
                          <option value="For Rent">For Rent</option>
                          <option value="Sold">Sold</option>
                        </select>
                      </div>

                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Zip code" required name="zipcode">
                      </div>


                      <br />
                      <div class="input-group" style="width:100%;">
                        <select class="form-control" style="width:100%;" name="agent_id">
                          <option value="None">Select Agent</option>
                          <?php
                              if($agents != null) {
                                  foreach ($agents as $agent)  {
                                        echo "<option value='$agent->agent_id'>$agent->name</option>";
                                  }
                              }
                          ?>
                          
                        </select>
                      </div>


                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Click on the Map for Latitude" name="lat" onkeypress='validateLatLng(event)' id="latitude" required>
                      </div>

                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <input type="text" class="form-control" placeholder="Click on the Map for Longitude" name="lon" onkeypress='validateLatLng(event)' id="longitude" required>
                      </div>

                      <br />
                      <div class="input-group">
                        <span class="input-group-addon"></span>
                        <textarea type="text" class="form-control" placeholder="Description" rows="10" name="desc1" id="details"></textarea>
                      </div>

                      <br /> 
                      <p>
                          <button type="submit" name="submit" class="btn btn-info" onclick="checkInput()" role="button">Save</button> 
                          <a class="btn btn-info" href="realestates.php" role="button">Cancel</a>
                      </p>
                  </form> 
                  


                </div>
                <div class="col-md-5">
                  <h4>Click the Map to get latitude/longitude:</h4>
                  <div id="map" style="width:100%; height:400px"></div>
               </div>
        </div>
      </div>


    </div> <!-- /container -->


    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="bootstrap/js/jquery.js"></script>
    <script src="bootstrap/js/bootstrap.js"></script>
    <script>
        function checkInput() {
            var website = document.getElementById("website");
            var details = document.getElementById("details");


            var website = document.getElementById("website");
            var details = document.getElementById("details");

            var strWebsite = website.value.replace("http://", "");
            strFb = strWebsite.replace("https://", "");
            website.value = strWebsite;

            var strDetails = details.value.replace("http://", "");
            strFb = strDetails.replace("https://", "");
            details.value = strDetails;
        }
    </script>
    
  

</body></html>