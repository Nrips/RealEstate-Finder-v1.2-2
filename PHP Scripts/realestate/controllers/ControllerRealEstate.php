<?php

class ControllerRealEstate
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
 
    public function updateRealEstate($itm) 
    {
        $stmt = $this->pdo->prepare('UPDATE tbl_realestate_realestates

                                        SET address = :address, 
                                            agent_id = :agent_id, 
                                            baths = :baths, 
                                            beds = :beds, 
                                            built_in = :built_in, 
                                            country = :country, 
                                            desc1 = :desc1, 
                                            featured = :featured, 
                                            lat = :lat, 
                                            lon = :lon, 
                                            lot_size = :lot_size, 
                                            price = :price, 
                                            price_per_sqft = :price_per_sqft, 
                                            property_type = :property_type, 
                                            rooms = :rooms, 
                                            sqft = :sqft, 
                                            status = :status, 
                                            updated_at = :updated_at, 
                                            zipcode = :zipcode 

                                        WHERE realestate_id = :realestate_id');

        $result = $stmt->execute(
                            array('address' => $itm->address,
                                    'agent_id' => $itm->agent_id,  
                                    'baths' => $itm->baths,
                                    'beds' => $itm->beds,
                                    'built_in' => $itm->built_in,
                                    'country' => $itm->country,
                                    'desc1' => $itm->desc1,
                                    'featured' => $itm->featured,
                                    'lat' => $itm->lat,
                                    'lon' => $itm->lon,
                                    'lot_size' => $itm->lot_size,
                                    'price' => $itm->price,
                                    'price_per_sqft' => $itm->price_per_sqft,
                                    'property_type' => $itm->property_type,
                                    'rooms' => $itm->rooms,
                                    'sqft' => $itm->sqft,
                                    'status' => $itm->status,
                                    'updated_at' => $itm->updated_at,
                                    'zipcode' => $itm->zipcode,
                                    'realestate_id' => $itm->realestate_id ) );
        
        return $result ? true : false;

    }


    public function deleteRealEstate($realestate_id, $is_deleted) 
    {
        $stmt = $this->pdo->prepare('UPDATE tbl_realestate_realestates 
                                        SET is_deleted = :is_deleted 
                                        WHERE realestate_id = :realestate_id ');
        
        $result = $stmt->execute(
                            array('realestate_id' => $realestate_id, 
                                    'is_deleted' => $is_deleted) );

        return $result ? true : false;
    }

    public function updateRealEstateFeatured($itm) 
    {
        $stmt = $this->pdo->prepare('UPDATE tbl_realestate_realestates 
                                        SET featured = :featured 
                                        WHERE realestate_id = :realestate_id ');
        
        $result = $stmt->execute(
                            array('realestate_id' => $itm->realestate_id, 
                                    'featured' => $itm->featured) );
        
        return $result ? true : false;
    }


    public function insertRealEstate($itm) 
    {
        $stmt = $this->pdo->prepare('INSERT INTO tbl_realestate_realestates( 
                                        address, 
                                        agent_id, 
                                        baths, 
                                        beds, 
                                        built_in, 
                                        country, 
                                        created_at, 
                                        desc1, 
                                        featured, 
                                        lat, 
                                        lon, 
                                        lot_size, 
                                        price, 
                                        price_per_sqft, 
                                        property_type, 
                                        rooms,
                                        sqft, 
                                        status, 
                                        updated_at, 
                                        zipcode ) 

                                    VALUES(
                                        :address, 
                                        :agent_id, 
                                        :baths, 
                                        :beds, 
                                        :built_in, 
                                        :country, 
                                        :created_at, 
                                        :desc1, 
                                        :featured, 
                                        :lat, 
                                        :lon, 
                                        :lot_size, 
                                        :price, 
                                        :price_per_sqft, 
                                        :property_type, 
                                        :rooms,
                                        :sqft, 
                                        :status, 
                                        :updated_at, 
                                        :zipcode )');
        
        $result = $stmt->execute(
                            array('address' => $itm->address,
                                    'agent_id' => $itm->agent_id,  
                                    'baths' => $itm->baths,
                                    'beds' => $itm->beds,
                                    'built_in' => $itm->built_in,
                                    'country' => $itm->country,
                                    'created_at' => $itm->created_at,
                                    'desc1' => $itm->desc1,
                                    'featured' => $itm->featured,
                                    'lat' => $itm->lat,
                                    'lon' => $itm->lon,
                                    'lot_size' => $itm->lot_size,
                                    'price' => $itm->price,
                                    'price_per_sqft' => $itm->price_per_sqft,
                                    'property_type' => $itm->property_type,
                                    'rooms' => $itm->rooms,
                                    'sqft' => $itm->sqft,
                                    'status' => $itm->status,
                                    'updated_at' => $itm->updated_at,
                                    'zipcode' => $itm->zipcode ) );
        
        return $result ? true : false;
    }
 

    public function getRealEstates() 
    {
        $stmt = $this->pdo->prepare('SELECT * 
                                        FROM tbl_realestate_realestates 
                                        WHERE is_deleted = 0 ORDER BY realestate_id DESC');
        
        $stmt->execute();

        $array = array();
        $ind = 0;
        foreach ($stmt as $row) 
        {
            $itm = new RealEstate();
            $itm->address = $row['address'];
            $itm->agent_id = $row['agent_id'];
            $itm->baths = $row['baths'];
            $itm->beds = $row['beds'];
            $itm->built_in = $row['built_in'];
            $itm->country = $row['country'];
            $itm->created_at = $row['created_at'];
            $itm->desc1 = $row['desc1'];
            $itm->featured = $row['featured'];
            $itm->lat = $row['lat'];
            $itm->lon = $row['lon'];
            $itm->lot_size = $row['lot_size'];
            $itm->price = $row['price'];
            $itm->price_per_sqft = $row['price_per_sqft'];
            $itm->property_type = $row['property_type'];
            $itm->realestate_id = $row['realestate_id'];
            $itm->rooms = $row['rooms'];
            $itm->sqft = $row['sqft'];
            $itm->status = $row['status'];
            $itm->updated_at = $row['updated_at'];
            $itm->zipcode = $row['zipcode'];

            $array[$ind] = $itm;
            $ind++;
        } 
        
        return $array;
    }

    public function getRealEstatesBySearching($search) 
    {
        $stmt = $this->pdo->prepare('SELECT * 
                                FROM tbl_realestate_realestates 
                                WHERE is_deleted = 0 AND address LIKE :search ORDER BY realestate_id DESC');
        
        $stmt->execute( array('search' => '%'.$search.'%'));

        $array = array();
        $ind = 0;
        foreach ($stmt as $row) 
        {
            $itm = new RealEstate();
            $itm->address = $row['address'];
            $itm->agent_id = $row['agent_id'];
            $itm->baths = $row['baths'];
            $itm->beds = $row['beds'];
            $itm->built_in = $row['built_in'];
            $itm->country = $row['country'];
            $itm->created_at = $row['created_at'];
            $itm->desc1 = $row['desc1'];
            $itm->featured = $row['featured'];
            $itm->lat = $row['lat'];
            $itm->lon = $row['lon'];
            $itm->lot_size = $row['lot_size'];
            $itm->price = $row['price'];
            $itm->price_per_sqft = $row['price_per_sqft'];
            $itm->property_type = $row['property_type'];
            $itm->realestate_id = $row['realestate_id'];
            $itm->rooms = $row['rooms'];
            $itm->sqft = $row['sqft'];
            $itm->status = $row['status'];
            $itm->updated_at = $row['updated_at'];
            $itm->zipcode = $row['zipcode'];

            $array[$ind] = $itm;
            $ind++;
        } 
        
        return $array;
    }


    public function getRealEstateByRealEstateId($realestate_id) 
    {
        
        $stmt = $this->pdo->prepare('SELECT * 
                                FROM tbl_realestate_realestates 
                                WHERE realestate_id = :realestate_id');
        
        $stmt->execute( array('realestate_id' => $realestate_id));

        foreach ($stmt as $row) 
        {
            $itm = new RealEstate();
            $itm->address = $row['address'];
            $itm->agent_id = $row['agent_id'];
            $itm->baths = $row['baths'];
            $itm->beds = $row['beds'];
            $itm->built_in = $row['built_in'];
            $itm->country = $row['country'];
            $itm->created_at = $row['created_at'];
            $itm->desc1 = $row['desc1'];
            $itm->featured = $row['featured'];
            $itm->lat = $row['lat'];
            $itm->lon = $row['lon'];
            $itm->lot_size = $row['lot_size'];
            $itm->price = $row['price'];
            $itm->price_per_sqft = $row['price_per_sqft'];
            $itm->property_type = $row['property_type'];
            $itm->realestate_id = $row['realestate_id'];
            $itm->rooms = $row['rooms'];
            $itm->sqft = $row['sqft'];
            $itm->status = $row['status'];
            $itm->updated_at = $row['updated_at'];
            $itm->zipcode = $row['zipcode'];

            return $itm;
        } 
        
        return null;
    }


    public function getRealEstateFeatured() 
    {
        $stmt = $this->pdo->prepare('SELECT * 
                                FROM tbl_realestate_realestates 
                                WHERE featured = 1 AND is_deleted = 0');
        
        $stmt->execute();

        $array = array();
        $ind = 0;
        foreach ($stmt as $row) 
        {
            $itm = new RealEstate();
            $itm->address = $row['address'];
            $itm->agent_id = $row['agent_id'];
            $itm->baths = $row['baths'];
            $itm->beds = $row['beds'];
            $itm->built_in = $row['built_in'];
            $itm->country = $row['country'];
            $itm->created_at = $row['created_at'];
            $itm->desc1 = $row['desc1'];
            $itm->featured = $row['featured'];
            $itm->lat = $row['lat'];
            $itm->lon = $row['lon'];
            $itm->lot_size = $row['lot_size'];
            $itm->price = $row['price'];
            $itm->price_per_sqft = $row['price_per_sqft'];
            $itm->property_type = $row['property_type'];
            $itm->realestate_id = $row['realestate_id'];
            $itm->rooms = $row['rooms'];
            $itm->sqft = $row['sqft'];
            $itm->status = $row['status'];
            $itm->updated_at = $row['updated_at'];
            $itm->zipcode = $row['zipcode'];

            $array[$ind] = $itm;
            $ind++;
        } 
        return $array;
    }

    public function getLastInsertedId() {

        return $this->pdo->lastInsertId(); 
    }

}
 
?>