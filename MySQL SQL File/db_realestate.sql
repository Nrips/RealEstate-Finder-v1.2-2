-- phpMyAdmin SQL Dump
-- version 4.0.8
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 08, 2014 at 12:34 PM
-- Server version: 5.5.34-cll-lve
-- PHP Version: 5.3.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `db_carfinder`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_realestate_agents`
--

CREATE TABLE IF NOT EXISTS `tbl_realestate_agents` (
  `agent_id` int(11) NOT NULL AUTO_INCREMENT,
  `address` text NOT NULL,
  `contact_no` varchar(100) NOT NULL,
  `country` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `sms` varchar(20) NOT NULL,
  `zipcode` varchar(20) NOT NULL,
  `photo_url` varchar(100) NOT NULL,
  `thumb_url` varchar(100) NOT NULL,
  `twitter` varchar(100) NOT NULL,
  `fb` varchar(100) NOT NULL,
  `linkedin` varchar(100) NOT NULL,
  `company` varchar(100) NOT NULL,
  `created_at` int(11) NOT NULL,
  `updated_at` int(11) NOT NULL,
  `is_deleted` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`agent_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `tbl_realestate_agents`
--

INSERT INTO `tbl_realestate_agents` (`agent_id`, `address`, `contact_no`, `country`, `email`, `name`, `sms`, `zipcode`, `photo_url`, `thumb_url`, `twitter`, `fb`, `linkedin`, `company`, `created_at`, `updated_at`, `is_deleted`, `user_id`) VALUES
(1, 'Daytona Beach, Florida', '+1 781-700-8811', 'Florida', 'jakefoxy@gmail.com', 'Jake Foxy', '+1 781-769-8800', '91234', 'http://www.themusicase.com/images/banner_home_mini.jpg', 'http://www.lanzycelebrity.com/wp-content/uploads/2014/02/Royalty-Free-Images.jpg', 'www.twitter.com/jakefoxy', 'www.facebook.com/jakefoxy', 'http://www.linkedin.com/pub/jake-foxy', 'The Foxy Company', 1401890979, 1402158798, 0, 9),
(2, 'Saint Paul, Minneapolis, MN', '+123 4565 667', 'California', 'tedd_bear@gmail.com', 'Tedd Bear', '+123 4565 6677', '12345', 'http://cdnec1.fiverrcdn.com/photos/2237304/v2_680/optima_ethereal1.jpg', 'http://www.miksmusic.com/wp-main/uploads/2013/11/mm1.png', 'www.twitter.com/teddbear', 'www.facebook.com/teddbear', 'http://www.linkedin.com/pub/tedd-bear/2a/251/586', 'Agent at Bean Realty Metro', 1401262522, 1402164295, 0, 7),
(3, '1730 South Maple Ave, Fresno, CA 93702', '+1 781-769-8800', 'Fresno, California', 'kateperry@gmail.com', 'Kate Perry', '+1 781-769-8800', '93702', 'http://cdnec0.fiverrcdn.com/photos/2757708/v2_680/optima_ukulele_royalty_free.jpg', 'http://www.draft.it/cms/images/2676.jpg', 'www.twitter.com/kateperry', 'www.facebook.com/kateperry', 'www.linkedin.com/pub/kateperry', 'Music Real Estate Company', 1402138282, 1402158987, 0, -1),
(4, 'Some Address for Dummy Users', '+123 4567 777', 'Some Country', 'dummyagent@gmail.com', 'Dummy Agent', '+123 3333 444', '89001', 'http://us.123rf.com/400wm/400/400/digifuture/digifuture1004/digifuture100400504/6917247-dark-brick-b', 'http://www.proheadshots.ca/wp-content/uploads/2012/09/real-estate-headshots.jpg', 'www.twitter.com/dummyagent', 'www.facebook.com/dummyagent', 'www,linkedin.com/pub/dummyagent', 'Dummy Company', 1402251964, 1402252410, 0, 2);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_realestate_authentication`
--

CREATE TABLE IF NOT EXISTS `tbl_realestate_authentication` (
  `authentication_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `role_id` int(11) NOT NULL,
  `is_deleted` int(11) NOT NULL,
  `deny_access` int(11) NOT NULL,
  PRIMARY KEY (`authentication_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `tbl_realestate_authentication`
--

INSERT INTO `tbl_realestate_authentication` (`authentication_id`, `username`, `password`, `name`, `role_id`, `is_deleted`, `deny_access`) VALUES
(1, 'admin', '3dba44de6dbf6ad13444799ed798f5b8', 'Admin', 1, 0, 0),
(2, 'guest', '25d55ad283aa400af464c76d713c07ad', 'Guest', 2, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_realestate_photos`
--

CREATE TABLE IF NOT EXISTS `tbl_realestate_photos` (
  `photo_id` int(11) NOT NULL AUTO_INCREMENT,
  `realestate_id` int(11) NOT NULL,
  `photo_url` varchar(200) NOT NULL,
  `thumb_url` varchar(200) NOT NULL,
  `created_at` int(11) NOT NULL,
  `updated_at` int(11) NOT NULL,
  `is_deleted` int(11) NOT NULL,
  PRIMARY KEY (`photo_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `tbl_realestate_photos`
--

INSERT INTO `tbl_realestate_photos` (`photo_id`, `realestate_id`, `photo_url`, `thumb_url`, `created_at`, `updated_at`, `is_deleted`) VALUES
(1, 1, 'http://uspropertyalacarte.com/wp-content/uploads/2013/04/Miami-Property-search.jpg', 'http://www.joanshaffer.com/agent_files/homes%20for%20sale%20in%20Denver%20Colorado%281%29.jpg', 1401962488, 0, 0),
(2, 1, 'http://2.bp.blogspot.com/_Th62Z0dJP-Q/S-_xuUWPDeI/AAAAAAAAAAw/nGv9wPmUHh8/s1600/Bequia+House,+The+Grenadines.jpg', 'http://www.janitattoo.com/img/6.jpg', 1401962548, 0, 0),
(3, 3, 'http://vegaspropertyinvesting.com/wp-content/uploads/2012/05/realestate.jpg', 'http://www.dreamhomegta.com/account/6fe272c66ea3ff73/pages/50599_5.jpg', 1401963246, 0, 1),
(4, 2, 'http://www.calgary2pointo.com/wp-content/uploads/2013/11/17.jpg', 'http://www.kaisa.ph/wp-content/uploads/2014/05/house.jpg', 1402134107, 0, 0),
(5, 2, 'https://aboutwholesalingrealestate.files.wordpress.com/2012/06/48.jpg', 'http://cdn.freshome.com/wp-content/uploads/2010/09/real-estate-house2-e1283999310846.jpg', 1402134652, 0, 0),
(6, 3, 'http://christinecerda.com/wp-content/uploads/christine-cerda-fresno-california-real-estate-homes-3.jpg', 'http://filelibrary.myaasite.com/Content/18/18291/29493020.jpg', 1402206935, 1402206935, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_realestate_propertytypes`
--

CREATE TABLE IF NOT EXISTS `tbl_realestate_propertytypes` (
  `propertytype_id` int(11) NOT NULL AUTO_INCREMENT,
  `property_type` varchar(200) NOT NULL,
  `created_at` varchar(50) NOT NULL,
  `updated_at` varchar(50) NOT NULL,
  `is_deleted` int(11) NOT NULL,
  PRIMARY KEY (`propertytype_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `tbl_realestate_propertytypes`
--

INSERT INTO `tbl_realestate_propertytypes` (`propertytype_id`, `property_type`, `created_at`, `updated_at`, `is_deleted`) VALUES
(1, 'New Homes', '1401262522', '1401262522', 0),
(2, 'Single-Family Home', '1401262522', '1401262522', 0),
(3, 'Bungalow', '1402126780', '1402244250', 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_realestate_realestates`
--

CREATE TABLE IF NOT EXISTS `tbl_realestate_realestates` (
  `realestate_id` int(11) NOT NULL AUTO_INCREMENT,
  `agent_id` int(11) NOT NULL,
  `address` text NOT NULL,
  `baths` varchar(50) NOT NULL,
  `beds` varchar(50) NOT NULL,
  `built_in` varchar(50) NOT NULL,
  `country` varchar(50) NOT NULL,
  `desc1` text NOT NULL,
  `featured` int(11) NOT NULL,
  `lat` varchar(50) NOT NULL,
  `lon` varchar(50) NOT NULL,
  `lot_size` varchar(50) NOT NULL,
  `price` varchar(50) NOT NULL,
  `price_per_sqft` varchar(50) NOT NULL,
  `property_type` varchar(50) NOT NULL,
  `rooms` varchar(50) NOT NULL,
  `sqft` varchar(50) NOT NULL,
  `status` varchar(50) NOT NULL,
  `zipcode` varchar(50) NOT NULL,
  `created_at` int(11) NOT NULL,
  `updated_at` int(11) NOT NULL,
  `is_deleted` int(11) NOT NULL,
  PRIMARY KEY (`realestate_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `tbl_realestate_realestates`
--

INSERT INTO `tbl_realestate_realestates` (`realestate_id`, `agent_id`, `address`, `baths`, `beds`, `built_in`, `country`, `desc1`, `featured`, `lat`, `lon`, `lot_size`, `price`, `price_per_sqft`, `property_type`, `rooms`, `sqft`, `status`, `zipcode`, `created_at`, `updated_at`, `is_deleted`) VALUES
(1, 1, '1519 E Bremer Ave Fresno, CA 93728, Fresno-High', '2', '3', '1935', 'California', 'Great investors property! 3 beds and 2 bathrooms, wood floors, being sold as is. Bring your buyers and sell this home.', 1, '36.71602671840956', '-119.76757046766579', '10,000 Sqft', '$89,900', '$64', 'Single-Family Home', '2', '1,410 Sqft', 'For Sale', '93728', 1401962042, 1402215923, 0),
(2, 2, 'N Glenn Ave, Fresno, California', '4', '5', '1970', 'Ohio', 'Good house for everyone which has an extended family. Nice and convenient. Very cozy place and children will love it for the rest of their life. Buy it now and pay it later. Contact Me. ASAP', 1, '36.752929', '-119.792378', '1,000 Sqft', '$100,000', '$70', 'Bungalo', '4', '4,000 Sqft', 'For Rent', '93730', 1401962973, 1402215914, 0),
(3, 3, '1519 E Huntington Ave Fresno, CA 93728, Fresno-High', '2', '4', '2012', 'California', 'Im sure you will love this place. It has absurb view, cozy place, relaxing, comfortable, huge playground for kids to play with. Contact me if interested. This is the best house in Fresno. Buy it now before it is too late.', 1, '36.74103238975292', '-119.74179982964415', '10,000 Sqft', '$205,890', '$64', 'New Homes', '4', '1,410 Sqft', 'For Sale', '93728', 1401262522, 1402215942, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_realestate_users`
--

CREATE TABLE IF NOT EXISTS `tbl_realestate_users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `full_name` varchar(50) NOT NULL,
  `username` varchar(40) NOT NULL,
  `password` varchar(40) NOT NULL,
  `login_hash` varchar(200) NOT NULL,
  `facebook_id` text NOT NULL,
  `twitter_id` text NOT NULL,
  `email` varchar(100) NOT NULL,
  `deny_access` int(11) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `tbl_realestate_users`
--

INSERT INTO `tbl_realestate_users` (`user_id`, `full_name`, `username`, `password`, `login_hash`, `facebook_id`, `twitter_id`, `email`, `deny_access`) VALUES
(1, 'John Doe', 'dummy_user', '81dc9bdb52d04dc20036dbd8313ed055', 'jEE55KHRaq0jq/VRrl7RaYZEeTNkMTE4ODk5MjNi', '', '', '', 0),
(2, 'Dummy Agent', 'dummy_agent', '25d55ad283aa400af464c76d713c07ad', 'cCghfv48jkpp7jLbsgbIwuEZ0ewxZDc5NzZlMGU2', '', '', 'dummy_agent@gmail.com', 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
