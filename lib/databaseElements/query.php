<?php
// Code inspired by Mobile Programmer, 2019 - https://www.youtube.com/watch?v=F4Q6lEhmwCY

	header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    // header("Access-Control-Allow-Methods: POST");
    // header("Access-Control-Max-Age: 3600");
    // header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
    
    
    require('connect.php');
    
    $action = '';
    $columns = '*';
    // $clause = '1=1';
    
    // User data
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        // $data = $_POST;
        // echo json_encode($data);
        $action = $_POST['action'];
	    $table = $_POST['table'];
        $columns = $_POST['columns'];
        $clause = $_POST['clause'];
    }
    

	switch ($action) {
		case 'GET_ALL':
			$query = "SELECT $columns FROM $table";
			$stm = $connection->prepare($query);
			$stm->execute();

			$num_results = $stm->rowCount();
    
			// Check if more than 0 records are found
			if ($num_results > 0) {
				$output = array();
				// $arr["records"] = array(); # Use if more than just results needed to be returned
			
				// Retrieve query results
				while ($row = $stm->fetch(PDO::FETCH_ASSOC)) {
					// Get all data back with keys being column names
					$output[] = $row;

					// Construct array with custom keys from column names
					/*
					extract($row);
					$item = array(
						"id" => $row['id'],
						// "name" => $row['dept_name']
					);
					// array_push($arr["records"], $item);
					array_push($output, $item);
					*/					
				}
				echo json_encode($output);

			} else {
				// Error
				$error = array();
				echo json_encode($error);
			}

			break;
		
		case 'GET_SELECTION':
			$query = "SELECT $columns FROM $table WHERE $clause";
			$stm = $connection->prepare($query);
			$stm->execute();

			$num_results = $stm->rowCount();
    
			// Check if more than 0 records are found
			if ($num_results > 0) {
				$output = array();
				
				// Retrieve query results
				while ($row = $stm->fetch(PDO::FETCH_ASSOC)) {
					$output[] = $row;			
				}
				echo json_encode($output);

			} else {
				// Error
				$error = array();
				echo json_encode($error);
			}
			break;

		case 'ADD_RECORD':
			$query = "INSERT INTO $table $columns VALUES $clause";
			$stm = $connection->prepare($query);

			if ($stm->execute() === TRUE) {
				echo json_encode("success");
			} else {
				echo json_encode("error");
			}

			break;

		case 'UPDATE_RECORD':
			$query = "UPDATE $table SET $columns WHERE $clause";
			$stm = $connection->prepare($query);

			if ($stm->execute() === TRUE) {
				echo json_encode("success");
			} else {
				echo json_encode("error");
			}

			break;

		case 'DELETE_RECORD':
			// $query = "DELETE FROM $table WHERE id = $emp_id";
			// $stm = $connection->prepare($query);

			// if ($stm->execute() === TRUE) {
			// 	echo "success";
			// } else {
			// 	echo "error";
			// }
			echo json_encode(array("message" => "Delete Not Implemented"));
			break;

		default:
			echo json_encode(array("message" => "No valid action"));
			break;
	}

    
?>