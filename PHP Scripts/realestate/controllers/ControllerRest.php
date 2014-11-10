<?php

 
class ControllerRest
{
 
    private $db;
    private $pdo;
    function __construct() 
    {
        // connecting to database
        $this->db = new DB_Connect();
        $this->pdo = $this->db->connect();
    }
 
    function __destruct() { }
 
    public function getPhotosResult() 
    {
        $stmt = $this->pdo->prepare('SELECT * FROM tbl_realestate_photos WHERE is_deleted = 0');

        $stmt->execute();
        return $stmt;
    }

    public function getAgentsResult() 
    {
        $stmt = $this->pdo->prepare('SELECT * FROM tbl_realestate_agents WHERE is_deleted = 0');
        $stmt->execute();
        return $stmt;
    }

    public function getRealEstateResult() 
    {
        $stmt = $this->pdo->prepare('SELECT * FROM tbl_realestate_realestates WHERE is_deleted = 0');
        $stmt->execute();
        return $stmt;
    }

    public function getCountriesResult() 
    {
        $stmt = $this->pdo->prepare('SELECT * FROM tbl_realestate_countries WHERE is_deleted = 0');
        $stmt->execute();
        return $stmt;
    }

    public function getPropertyTypeResult() 
    {
        $stmt = $this->pdo->prepare('SELECT * FROM tbl_realestate_propertytypes WHERE is_deleted = 0');
        $stmt->execute();
        return $stmt;
    }

}
 
?>