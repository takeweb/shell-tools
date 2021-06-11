SELECT
   serial_no
  , TO_CHAR(locate_date, 'YYYYMMDDHH24MISS')
FROM
  location_historys
WHERE
  serial_no = :imei
  AND TO_CHAR(locate_date, 'YYYYMMDDHH24MISS') = :locate_date  
;
