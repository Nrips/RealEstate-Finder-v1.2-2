<?php

  require '../header_rest.php';
  $controllerRest = new ControllerRest();

  $resultPhoto = $controllerRest->getPhotosResult();
  $resultAgents = $controllerRest->getAgentsResult();
  $resultRealEstates = $controllerRest->getRealEstateResult();
  $resultPropertyType = $controllerRest->getPropertyTypeResult();
  

  
  header ("content-type: text/xml");
  // header("Content-Type: application/xml; charset=ISO-8859-1");
  echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
  echo "<data>";

      // PHOTOS
      echo "<photos>";
      foreach ($resultPhoto as $row) 
      {
          echo"<item>";
          foreach ($row as $columnName => $field) 
          {

            $val = trim(strip_tags($field));
            if(!is_numeric($columnName)) {
                echo "<$columnName>$val</$columnName>";
            }
          }
          echo"</item>";
      }
      echo "</photos>";
      

      // AGENTS
      echo "<agents>";
      foreach ($resultAgents as $row) 
      {
          echo"<item>";
          foreach ($row as $columnName => $field) 
          {

            $val = trim(strip_tags($field));
            if(!is_numeric($columnName)) {
                echo "<$columnName>$val</$columnName>";
            }
          }
          echo"</item>";
      }
      echo "</agents>";


      // REAL ESTATES
      echo "<real_estates>";
      foreach ($resultRealEstates as $row) 
      {
          echo"<item>";
          foreach ($row as $columnName => $field) 
          {

            $val = trim(strip_tags($field));
            if(!is_numeric($columnName)) {
                echo "<$columnName>$val</$columnName>";
            }
          }
          echo"</item>";
      }
      echo "</real_estates>";


      // COUNTRIES
      echo "<property_types>";
      foreach ($resultPropertyType as $row) 
      {
          echo"<item>";
          foreach ($row as $columnName => $field) 
          {

            $val = trim(strip_tags($field));
            if(!is_numeric($columnName)) {
                echo "<$columnName>$val</$columnName>";
            }
          }
          echo"</item>";
      }
      echo "</property_types>";

  
  echo "</data>";

?>