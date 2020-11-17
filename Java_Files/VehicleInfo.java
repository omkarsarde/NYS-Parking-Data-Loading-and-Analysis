import java.sql.*;

/**
 * @author1 : Omkar Sarde
 * @author2 : Sharwari Salunkhe
 * version : 1.1
 */


/**
 * This class contains a query to get the count of the cars for top 5 states.
 */
public class VehicleInfo {

    /**
     * This method gets results for the query to get the top 5 states
     * with most number of cars in NYC
     * @throws SQLException
     */
    public void StatewiseCarCount() throws SQLException {
        String url = "jdbc:mysql://localhost:3306?serverTimezone=UTC&allowLoadLocalInfile=true&dbname=parkingViolations";
        String user = "root";
        String pwd = "123"; // change password for yourself here
        Connection conn = DriverManager.getConnection(url, user, pwd);
        Statement stmt = conn.createStatement();

        String query = " select registrationState,count(plateId) as count from vehicleInfo\n" +
                " group by registrationState " +
                " order by count desc" +
                " limit 5";

        // get result here
        ResultSet rs = stmt.executeQuery(query);
        while (rs.next()){
            String state = rs.getNString(1);
            int count = rs.getInt(2);
            System.out.println("state "+ state+" count "+ count);
        }
        stmt.close();
        conn.close();
    }

    /**
     * Main method
     * @param args
     * @throws SQLException
     */
    public static void main(String[] args) throws SQLException {
        VehicleInfo vehicleInfo = new VehicleInfo();
        vehicleInfo.StatewiseCarCount();
    }
}
