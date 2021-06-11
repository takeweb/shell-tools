SELECT
   count(serial_no)
FROM
  location_historys
WHERE
  serial_no = :imei
  AND TO_CHAR(locate_date, 'YYYYMMDDHH24MISS') = :locate_date  
;
