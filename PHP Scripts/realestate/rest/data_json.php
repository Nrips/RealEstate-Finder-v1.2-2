<?php

  require '../header_rest.php';
  $controllerRest = new ControllerRest();

  $resultPhoto = $controllerRest->getPhotosResult();
  $resultAgents = $controllerRest->getAgentsResult();
  $resultRealEstates = $controllerRest->getRealEstateResult();
  $resultPropertyType = $controllerRest->getPropertyTypeResult();

  

  header ("content-type: text/json");
  // header("Content-Type: application/text; charset=ISO-8859-1");
  echo "{";

            // PHOTOS
            echo "\"photos\" : [";
            $no_of_rows = $resultPhoto->rowCount();
            $ind = 0;
            $count = $resultPhoto->columnCount();
            foreach ($resultPhoto as $row) 
            {
                echo "{";
                $inner_ind = 0;
                foreach ($row as $columnName => $field) 
                {

                    $val = trim(strip_tags($field));
                    if(!is_numeric($columnName)) {
                        echo "\"$columnName\" : \"$val\"";

                        if($inner_ind < $count - 1)
                          echo ",";

                        ++$inner_ind;
                    }
                }
                echo "}";

                if($ind < $no_of_rows - 1)
                  echo ",";

                ++$ind;
            }
            echo "], ";

            // AGENTS
            echo "\"agents\" : [";
            $no_of_rows = $resultAgents->rowCount();
            $ind = 0;
            $count = $resultAgents->columnCount();
            foreach ($resultAgents as $row) 
            {
                echo "{";
                $inner_ind = 0;
                foreach ($row as $columnName => $field) 
                {

                    $val = trim(strip_tags($field));
                    if(!is_numeric($columnName)) {
                        echo "\"$columnName\" : \"$val\"";

                        if($inner_ind < $count - 1)
                          echo ",";

                        ++$inner_ind;
                    }
                }
                echo "}";

                if($ind < $no_of_rows - 1)
                  echo ",";

                ++$ind;
            }
            echo "], ";


            // REAL ESTATES
            echo "\"real_estates\" : [";
            $no_of_rows = $resultRealEstates->rowCount();
            $ind = 0;
            $count = $resultRealEstates->columnCount();
            foreach ($resultRealEstates as $row) 
            {
                echo "{";
                $inner_ind = 0;
                foreach ($row as $columnName => $field) 
                {

                    $val = trim(strip_tags($field));
                    if(!is_numeric($columnName)) {
                        echo "\"$columnName\" : \"$val\"";

                        if($inner_ind < $count - 1)
                          echo ",";

                        ++$inner_ind;
                    }
                }
                echo "}";

                if($ind < $no_of_rows - 1)
                  echo ",";

                ++$ind;
            }
            echo "], ";


            // COUNTRIES
            echo "\"property_types\" : [";
            $no_of_rows = $resultPropertyType->rowCount();
            $ind = 0;
            $count = $resultPropertyType->columnCount();
            foreach ($resultPropertyType as $row) 
            {
                echo "{";
                $inner_ind = 0;
                foreach ($row as $columnName => $field) 
                {

                    $val = trim(strip_tags($field));
                    if(!is_numeric($columnName)) {
                        echo "\"$columnName\" : \"$val\"";

                        if($inner_ind < $count - 1)
                          echo ",";

                        ++$inner_ind;
                    }
                }
                echo "}";

                if($ind < $no_of_rows - 1)
                  echo ",";

                ++$ind;
            }
            echo "] ";

       
  echo "}";
?>