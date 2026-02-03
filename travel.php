<?php
include 'condb.php';


try {
    $stmt = $conn->prepare("SELECT * FROM travel");
    $stmt->execute();
    $sql_data = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        "success" => true,
        "data" => $sql_data
    ]);
} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "message" => $e->getMessage()
    ]);
}
?>