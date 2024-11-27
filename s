   private readonly string connectionString = @"Server=DESKTOP-05KJMFJ;Database=v&;Trusted_Connection=true;MultipleActiveResultSets=true;TrustServerCertificate=true;encrypt=false";
   protected SqlConnection GetConnection()
   {
       return new SqlConnection(connectionString);
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
          command.CommandText = "select role_user from users where name = @login and password_user = @password ";

          command.Parameters.Add("login", System.Data.SqlDbType.NVarChar).Value = login;
          command.Parameters.Add("password", System.Data.SqlDbType.NVarChar).Value = password;
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
          else
          {
              MessageBox.Show("Проверьте корректность введенных данных");
          }

      }


  }

  private void CreateUser_Click(object sender, RoutedEventArgs e)
{
    try
    {
        using (SqlConnection conn = GetConnection())
        using (var command = new SqlCommand(connectionString))
        {
            conn.Open();
            command.Connection = conn;
            command.CommandText = "insert into users (name, password_user, role_user) values (@Name, @Password, @Role)";
            command.Parameters.Add("Name", System.Data.SqlDbType.NVarChar).Value = Name.Text;
            command.Parameters.Add("Password", System.Data.SqlDbType.NVarChar).Value = Password.Text;
            command.Parameters.Add("Role", System.Data.SqlDbType.NVarChar).Value = Role.Text;

            command.ExecuteNonQuery();
            MessageBox.Show("Пользователь успешно создан", "Успешно", MessageBoxButton.OK);
            this.Close();   
        }
    }
    catch (Exception ex)
    {
        MessageBox.Show(ex.Message);
    }
 

}

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
