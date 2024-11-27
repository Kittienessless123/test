private readonly string connectionString = @"Server=DESKTOP-05KJMFJ;Database=v&;Trusted_Connection=true;MultipleActiveResultSets=true;TrustServerCertificate=true;encrypt=false";

 public UserWindow()
 {
     InitializeComponent();


     SqlConnection connection = new SqlConnection(connectionString);
     connection.Open();
     string cmd = "SELECT * FROM Users";
     SqlCommand createCommand = new SqlCommand(cmd, connection);
     createCommand.ExecuteNonQuery();
     SqlDataAdapter dataAdp = new SqlDataAdapter(createCommand);
     DataTable dt = new DataTable("Users");
     dataAdp.Fill(dt);
     UserList.ItemsSource = dt.DefaultView;
     connection.Close();


 }

 private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
 {

     var result = MessageBox.Show("Вы уверены что хотите выйти?", "Выход из приложения", MessageBoxButton.YesNo, MessageBoxImage.Exclamation);
     if (result == MessageBoxResult.No)
     {
         e.Cancel = true;
         return;
     }
     else
     {
         Application.Current.Shutdown();
     }


 }

 private void CreateUser_cLick(object sender, RoutedEventArgs e)
 {
     CreateUserWindow createUserWindow = new CreateUserWindow();
     createUserWindow.ShowDialog();
 }
namespace WpfApp4
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private readonly string connectionString = @"Server=DESKTOP-05KJMFJ;Database=v&;Trusted_Connection=true;MultipleActiveResultSets=true;TrustServerCertificate=true;encrypt=false";
        protected SqlConnection GetConnection()
        {
            return new SqlConnection(connectionString);
        }

        public MainWindow()
        {
            InitializeComponent();
        }

        private void SignIn_CLick(object sender, RoutedEventArgs e)
        {

            if (string.IsNullOrEmpty(Login.Text) || string.IsNullOrEmpty(Password.Text))
            {
                MessageBox.Show("Password or login is null");
            }
            else
            {
                try
                {
                    AuthencticateUser(Login.Text, Password.Text);
                }
                catch (SqlException ex)
                {
                    MessageBox.Show(ex.Message);
                }


            }
        }

        private void Window_Сlosing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            var result = MessageBox.Show("Вы уверены что хотите выйти?", "Выход из приложения", MessageBoxButton.YesNo, MessageBoxImage.Exclamation);
            if (result == MessageBoxResult.No)
            {
                e.Cancel = true;
                return;
            }
            else
            {
                Application.Current.Shutdown();
            }

        }
        public void AuthencticateUser(string login, string password)
        {
            string Role = "";
            using (var conn = GetConnection())
            using (var command = new SqlCommand())
            {
                conn.Open();
                command.Connection = conn;
                command.CommandText = $"select role_user from users where name = {login} and password_user = {password} ";

                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Role = reader["role_user"].ToString();

                    }
                }
                if (Role == "admin")
                {
                    AdminWindow admin = new AdminWindow();
                    admin.Show();
                    this.Hide();
                }
                else if (Role == "user")
                {
                    UserWindow user = new UserWindow();
                    user.Show();
                    this.Hide();

                }

            }


        }

    }
}

