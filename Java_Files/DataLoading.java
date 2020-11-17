import java.sql.*;

/**
 * @author1 : Omkar Sarde
 * @author2 : Sharwari Salunkhe
 * version : 1.1
 */

/**
 * This class loads the NYC Parking Violations dataset
 * in MySQL server using JDBC connector.
 */
public class DataLoading {

    static Connection conn = null;
    static PreparedStatement ps = null;
    static Statement stmt = null;
    static long startTime, duration;
    // change db name according to your db name in link as well
    static String url = "jdbc:mysql://localhost:3306?serverTimezone=UTC&allowLoadLocalInfile=true&dbname=parkingViolations";
    static String user = "root";
    // change password here
    static String pwd = "123";
    static String violationCodesFileLocation = "C:/BDProject/src/Violation_codes.csv";
    static String[] fileLocations = {"C:/BDProject/src/PV2020.csv", "C:/BDProject/src/PV2019.csv",
            "C:/BDProject/src/PV2018.csv", "C:/BDProject/src/PV2017.csv"};

    public static void main(String[] args) throws Exception {
        // these can be taken as arguments later
        String dbURL = "jdbc:mysql://localhost:3306?serverTimezone=UTC&allowLoadLocalInfile=true&dbname=parkingViolations";
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, user, pwd);
        stmt = conn.createStatement();
        System.out.println("Connected to the database");
        stmt = conn.createStatement();
        // comment the next 2 line once you run it for the first time
        String sql = "CREATE DATABASE ParkingViolations";
        stmt.executeUpdate(sql);
        System.out.println("Database created successfully...");
        createTables();
        LoadViolationCodesData();
        loadVehicleInfo();
        loadIssuerInfo();
        loadParkingViolationsData();

    }

    /**
     * Method to create all tables from the schema
     *
     * @throws SQLException
     */
    public static void createTables() throws SQLException {
        stmt = conn.createStatement();
        // change dbName if you want
        stmt.executeUpdate("USE ParkingViolations");
        String vehicleTable = "CREATE TABLE IF NOT EXISTS vehicleInfo" +
                "( plateID VARCHAR(100) not null, " +
                " registrationState VARCHAR(100) not null," +
                " plateType VARCHAR(100) not null," +
                " bodyType VARCHAR(100) null," +
                " make VARCHAR(100) null," +
                " expirationDate INTEGER null," + // expiration date
                " color VARCHAR(100) null," +
                " vehicleYear INTEGER null," +
                " PRIMARY KEY(plateID, registrationState) )";
        ps = conn.prepareStatement(vehicleTable);
        ps.executeUpdate(vehicleTable);

        // table 2
        String violationCodeTable = "create table if not exists violationCode(\n" +
                "violationCode int not null primary key,\n" +
                "violationDefinition varchar(200),\n" +
                "fine_Manhattan96thStreetAndBelow int,\n" +
                "fine_AllOtherAreas int\n" +
                ");";
        ps = conn.prepareStatement(violationCodeTable);
        ps.executeUpdate(violationCodeTable);

        // table 3
        String issuerInfoTable = "create table if not exists issuerInfo(\n" +
                "id int not null primary key auto_increment,\n" +
                "issuerCode int,\n" +
                "squad varchar(100),\n" +
                "command varchar(100),\n" +
                "precinctId int,\n" +
                "agency varchar(100),\n" +
                "unique key(issuerCode,squad,command,precinctId,agency)\n" +
                ");";
        ps = conn.prepareStatement(issuerInfoTable);
        ps.executeUpdate(issuerInfoTable);

        // table 4
        String parkingViolationTable = "create table parkingViolation(\n" +
                "summonsId int not null,\n" +
                "vehiclePlateNumber varchar(100),\n" +
                "vehicleRegistrationState varchar(100),\n" +
                "issueDate DATETIME,\n" +
                "violationCode int not null,\n" +
                "streetCode1 int,\n" +
                "streetCode2 int,\n" +
                "streetCode3 int,\n" +
                "violationLocation int,\n" +
                "violationPrecinctId int,\n" +
                "violationTime varchar(100),\n" +
                "violationCounty varchar(100),\n" +
                "streetName varchar(100),\n" +
                "lawSection int,\n" +
                "subDivision varchar(100),\n" +
                "violationLegalCode int,\n" +
                "daysParkingInEffect varchar(100),\n" +
                "fromHoursParkingInEffect varchar(100),\n" +
                "toHoursParkingInEffect varchar(100),\n" +
                "UnregisteredVehicle int,\n" +
                "FeetFromCurb int,\n" +
                "violationPostCode int,\n" +
                "violationDescription varchar(200),\n" +
                "issuerId int,\n" +
                "primary key(summonsId),\n" +
                "CONSTRAINT FK_violation_Code FOREIGN KEY (violationCode) REFERENCES violationCode(violationCode),\n" +
                "CONSTRAINT FK_violation_issuerId FOREIGN KEY(issuerId) REFERENCES issuerInfo(id),\n" +
                "CONSTRAINT FK_violation_vehicle_plate_state FOREIGN KEY(vehiclePlateNumber,vehicleRegistrationState) REFERENCES vehicleInfo(plateId,registrationState)\n" +
                ");";
        ps = conn.prepareStatement(parkingViolationTable);
        ps.executeUpdate(parkingViolationTable);
        // Closing Connection
        ps.close();
        conn.close();

    }

    /**
     * Method to insert data in the vehicle info table
     *
     * @throws Exception
     */
    public static void loadVehicleInfo() throws Exception {
        Connection conn = DriverManager.getConnection(url, user, pwd);
        Statement stmt = conn.createStatement();
        // conn.setAutoCommit(false);
        System.out.println("Loading data into table vehicleInfo");

        startTime = System.nanoTime();
        // query to insert data into table
        for (int i = 0; i < 4; i++) {
            String query = " LOAD DATA local INFILE '" + fileLocations[i] +
                    "' INTO TABLE vehicleInfo\n" +
                    "FIELDS TERMINATED BY ','\n" +
                    "LINES TERMINATED BY '\\n'\n" +
                    "IGNORE 1 LINES\n" +
                    "(@SummonsNumber,@PlateId,@RegistrationState,@PlateType,@IssueDate,@ViolationCode,@VehicleBodyType,@VehicleMake,@IssuingAgency,\n" +
                    "@StreetCode1,@StreetCode2,@StreetCode3,@VehicleExpirationDate,@ViolationLocation,@ViolationPrecinct,@IssuerPrecinct,@IssuerCode,\n" +
                    "@IssuerCommand,@IssuerSquad,@ViolationTime,@TimeFirstObserved,@ViolationCounty,@ViolationInFrontOfOrOpposite,@HouseNumber,@StreetName,\n" +
                    "@IntersectingStreet,@DateFirstObserved,@LawSection,@SubDivision,@ViolationLegalCode,@DaysParkingInEffect,@FromHoursInEffect,@ToHoursInEffect,\n" +
                    "@VehicleColor,@UnregisteredVehicle,@VehicleYear,@MeterNumber,@FeetFromCurb,@ViolationPostCode,@ViolationDescription,@NoStandingorStoppingViolation,@HydrantViolation,@DoubleParkingViolation)\n" +
                    "SET plateId = @PlateId,plateType=@PlateType,bodyType = @VehicleBodyType, make=@VehicleMake,expirationDate = @VehicleExpirationDate,color = @VehicleColor,vehicleYear = @VehicleYear,registrationState = @RegistrationState;\n";
            stmt.executeQuery(query);
            System.out.println("Inserted data from " + fileLocations[i]);
        }
        duration = System.nanoTime() - startTime;
        System.out.println("Time taken for loading data in vehicleInfo table: " + duration);

        stmt.close();
        conn.close();

    }

    /**
     * Load the issuer precinct data from every year file
     *
     * @throws Exception
     */
    public static void loadIssuerInfo() throws Exception {

        Connection conn = DriverManager.getConnection(url, user, pwd);
        Statement stmt = conn.createStatement();
        // conn.setAutoCommit(false);
        System.out.println("Loading data into table issuerInfo");
        startTime = System.nanoTime();
        // query to insert data into table
        for (int i = 0; i < 4; i++) {
            String query = " LOAD DATA local INFILE '" + fileLocations[i] +
                    "' IGNORE\n" +
                    "  INTO TABLE issuerInfo\n" +
                    " FIELDS TERMINATED BY ','\n" +
                    " LINES TERMINATED BY '\\n'\n" +
                    " IGNORE 1 LINES\n" +
                    " (@SummonsNumber,@PlateId,@RegistrationState,@PlateType,@IssueDate,@ViolationCode,@VehicleBodyType,@VehicleMake,@IssuingAgency,\n" +
                    " @StreetCode1,@StreetCode2,@StreetCode3,@VehicleExpirationDate,@ViolationLocation,@ViolationPrecinct,@IssuerPrecinct,@IssuerCode,\n" +
                    " @IssuerCommand,@IssuerSquad,@ViolationTime,@TimeFirstObserved,@ViolationCounty,@ViolationInFrontOfOrOpposite,@HouseNumber,@StreetName,\n" +
                    " @IntersectingStreet,@DateFirstObserved,@LawSection,@SubDivision,@ViolationLegalCode,@DaysParkingInEffect,@FromHoursInEffect,@ToHoursInEffect,\n" +
                    " @VehicleColor,@UnregisteredVehicle,@VehicleYear,@MeterNumber,@FeetFromCurb,@ViolationPostCode,@ViolationDescription,@NoStandingorStoppingViolation,@HydrantViolation,@DoubleParkingViolation)\n" +
                    " SET issuerCode = @IssuerCode, squad = @IssuerSquad ,command = @IssuerCommand,precinctId= @IssuerPrecinct,agency = @IssuingAgency;";
            stmt.executeQuery(query);
            System.out.println("Inserted data from " + fileLocations[i]);
        }
        duration = System.nanoTime() - startTime;
        System.out.println("Time taken for loading data in issuerInfo table: " + duration);

        stmt.close();
        conn.close();

    }

    /**
     * Load the data for the parking violations table
     * the path for files is a little different as each large csv file
     * is divided into multiple small files.
     * The file can be loaded using single year wise file but this way reduces time to load data
     *
     * @throws Exception
     */
    public static void loadParkingViolationsData() throws Exception {
        Connection conn = DriverManager.getConnection(url, user, pwd);
        Statement stmt = conn.createStatement();
        // conn.setAutoCommit(false);
        System.out.println("Loading data into table parkingViolation");
        startTime = System.nanoTime();
        char[] alphabets = "abcdefghijklmnopqrstuvwx".toCharArray();
        String[] fileLocations = {"C:/BigData_Summer/BDProject/src/2020/xa", "C:/BigData_Summer/BDProject/src/2019/xa",
                "C:/BigData_Summer/BDProject/src/2018/xa", "C:/BigData_Summer/BDProject/src/2017/xa"};
        // query to insert data into table
        for (int i = 2; i < 4; i++) {
            for (int j = 0; j < 24; j++) {
                String query = " LOAD DATA local INFILE '" + fileLocations[i] + alphabets[j] + ".csv" +
                        "' IGNORE INTO TABLE parkingViolation\n" +
                        " FIELDS TERMINATED BY ','\n" +
                        " LINES TERMINATED BY '\\n'\n" +
                        //  " IGNORE 1 LINES\n" +
                        "(@SummonsNumber,@PlateId,@RegistrationState,@PlateType,@IssueDate,@ViolationCode,@VehicleBodyType,@VehicleMake,@IssuingAgency,\n" +
                        "@StreetCode1,@StreetCode2,@StreetCode3,@VehicleExpirationDate,@ViolationLocation,@ViolationPrecinct,@IssuerPrecinct,@IssuerCode,\n" +
                        "@IssuerCommand,@IssuerSquad,@ViolationTime,@TimeFirstObserved,@ViolationCounty,@ViolationInFrontOfOrOpposite,@HouseNumber,@StreetName,\n" +
                        "@IntersectingStreet,@DateFirstObserved,@LawSection,@SubDivision,@ViolationLegalCode,@DaysParkingInEffect,@FromHoursInEffect,@ToHoursInEffect,\n" +
                        "@VehicleColor,@UnregisteredVehicle,@VehicleYear,@MeterNumber,@FeetFromCurb,@ViolationPostCode,@ViolationDescription,@NoStandingorStoppingViolation,@HydrantViolation,@DoubleParkingViolation)\n" +
                        "SET summonsId = @SummonsNumber,vehiclePlateNumber = @PlateId,vehicleRegistrationState = @RegistrationState, issueDate = @IssueDate, violationCode = @ViolationCode ,streetCode1 = @StreetCode1,streetCode2 = @StreetCode2,\n" +
                        "streetCode3 = @StreetCode3,violationLocation = (select 0 where @ViolationLocation=''),violationPrecinctId = @ViolationPrecinct,violationTime = @ViolationTime,violationCounty = @ViolationCounty,\n" +
                        "streetName = @StreetName,lawSection = @LawSection,subDivision = @SubDivision,violationLegalCode = (select 0 where @ViolationLegalCode=''),daysParkingInEffect = @DaysParkingInEffect,\n" +
                        "fromHoursParkingInEffect = @FromHoursInEffect,toHoursParkingInEffect = @ToHoursInEffect,UnregisteredVehicle = (select 0 where @UnregisteredVehicle=''),FeetFromCurb = (select 0 where @FeetFromCurb=''),\n" +
                        "violationPostCode = (select 0 where @ViolationPostCode=''),violationDescription = @ViolationDescription";
                try {
                    stmt.executeQuery(query);
                } catch (SQLException e) {
                    System.out.println(e);
                }
                System.out.println(query);
                System.out.println("Inserted data from '" + fileLocations[i] + alphabets[j] + ".csv'");
            }
        }
        duration = System.nanoTime() - startTime;
        System.out.println("Time taken for loading data in parkingViolation table: " + duration);

        stmt.close();
        conn.close();

    }

    /**
     * Load all the violation codes, their descriptions and fines for manhattan and other streets
     *
     * @throws SQLException
     */
    public static void LoadViolationCodesData() throws SQLException {
        Connection conn = DriverManager.getConnection(url, user, pwd);
        Statement stmt = conn.createStatement();
        long startTime, duration;
        String query = "LOAD DATA local INFILE  \'" + violationCodesFileLocation + "\' " +
                " IGNORE" +
                " INTO TABLE violationCode " +
                " FIELDS TERMINATED BY \',\' " +
                " LINES TERMINATED BY \'\\n\'" +
                " IGNORE 1 LINES" +
                " (@ViolationCODE,@ViolationDEFINITION,@Fine_Manhattan96thSt._below,@Fine_AllOtherAreas)" +
                " SET violationCode = @ViolationCODE," +
                " violationDefinition = @ViolationDEFINITION," +
                " fine_Manhattan96thStreetAndBelow = @Fine_Manhattan96thSt._below," +
                " fine_AllOtherAreas = @Fine_AllOtherAreas";
        startTime = System.nanoTime();
        try {
            stmt.executeQuery(query);
        } catch (SQLException e) {
            System.out.println(e);
        }
        duration = System.nanoTime() - startTime;
        System.out.println("Inserted data from " + violationCodesFileLocation);
        // 2020 1786829521513
        System.out.println("Time taken for loading data in violationCode table: " + duration);
        stmt.close();
        conn.close();
    }

}


