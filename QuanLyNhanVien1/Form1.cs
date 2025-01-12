using System;
using System.Collections.Generic;
using System.Windows.Forms;

namespace QuanLyNhanVien1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            LoadDgv();
            LoadCbb();
        }

        private void LoadDgv()
        {
            dgvLoad.DataSource = Database.Query("select * from NhanVien");
            btnUpdate.Enabled = btnDelete.Enabled = dgvLoad.Rows.Count > 0;
        }

        private void LoadCbb()
        {
            cbbDepart.DataSource = Database.Query("select * from PhongBan");
            cbbDepart.DisplayMember = "TenPhongBan";
            cbbDepart.ValueMember = "MaPhongBan";
        }

        private bool Check()
        {
            bool check = true;
            erp_loi.Clear();
            if (String.IsNullOrEmpty(txtId.Text))
            {
                erp_loi.SetError(txtId, "ID khong duoc de trong");
                check = false;
            }
            if (String.IsNullOrEmpty(txtName.Text))
            {
                erp_loi.SetError(txtName, "Ten khong duoc de trong");
                check = false;
            }
            if (String.IsNullOrEmpty(txtSalary.Text))
            {
                erp_loi.SetError(txtSalary, "Luong khong duoc de trong");
                check = false;
            }
            return check;
        }

        private void btnAddd_Click(object sender, EventArgs e)
        {
            if(Check() == false)
            {
                return;
            }
            string sql = "EXEC ThemNhanVien @MaNhanVien, @HoTen, @MaPhongBan, @NgayVaoLam, @MucLuong";
            Dictionary<string, object> dictionary = new Dictionary<string, object>();
            dictionary.Add("@MaNhanVien", txtId.Text);
            dictionary.Add("@HoTen", txtName.Text);
            dictionary.Add("@MaPhongBan", cbbDepart.SelectedValue);
            dictionary.Add("@NgayVaoLam", dtpStart.Value.ToString("yyyy-MM-dd"));
            dictionary.Add("@MucLuong", txtSalary.Text);
            try
            {
                Database.Execute(sql, dictionary);
                LoadDgv();
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void btnUpdate_Click(object sender, EventArgs e)
        {
            if (Check() == false)
            {
                return;
            }
            string sql = "EXEC SuaNhanVien @MaNhanVien, @HoTen, @MaPhongBan, @NgayVaoLam, @MucLuong";
            Dictionary<string, object> dictionary = new Dictionary<string, object>();
            dictionary.Add("@MaNhanVien", txtId.Text);
            dictionary.Add("@HoTen", txtName.Text);
            dictionary.Add("@MaPhongBan", cbbDepart.SelectedValue);
            dictionary.Add("@NgayVaoLam", dtpStart.Value.ToString("yyyy-MM-dd"));
            dictionary.Add("@MucLuong", txtSalary.Text);
            try
            {
                Database.Execute(sql, dictionary);
                LoadDgv();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void btnDelete_Click(object sender, EventArgs e)
        {
            string sql = "EXEC XoaNhanVien @MaNhanVien";
            Dictionary<string, object> dictionary = new Dictionary<string, object>();
            dictionary.Add("@MaNhanVien", txtId.Text);
            try
            {
                DialogResult result = MessageBox.Show("Ban co chac muon xoa khong", "ThongBao", MessageBoxButtons.YesNo);
                if(result == DialogResult.Yes)
                {
                    Database.Execute(sql, dictionary);
                    LoadDgv();
                    txtId.Text = txtName.Text = txtSalary.Text = "";
                }
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void dgvLoad_RowEnter(object sender, DataGridViewCellEventArgs e)
        {
            txtId.Text = dgvLoad.Rows[e.RowIndex].Cells["colMaNhanVien"].Value.ToString();
            txtName.Text = dgvLoad.Rows[e.RowIndex].Cells["colHoTen"].Value.ToString();
            cbbDepart.SelectedValue = dgvLoad.Rows[e.RowIndex].Cells["colMaPhongBan"].Value.ToString();
            dtpStart.Value = Convert.ToDateTime(dgvLoad.Rows[e.RowIndex].Cells["colNgayVaoLam"].Value.ToString());
            txtSalary.Text = dgvLoad.Rows[e.RowIndex].Cells["colMucLuong"].Value.ToString();
        }

        private void btnFind_Click(object sender, EventArgs e)
        {
            string sql = "select * from TimKiemNhanVien(@TuKhoa)";
            Dictionary<string, object> dictionary = new Dictionary<string, object>();
            if (cbFind.Checked)
            {
                dictionary.Add("@TuKhoa", txtFind.Text);
            }
            else
            {
                dictionary.Add("@TuKhoa", DBNull.Value);
            }
            dgvLoad.DataSource = Database.Query(sql, dictionary);
        }

        private void btnReset_Click(object sender, EventArgs e)
        {
            LoadDgv();
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void txtId_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (char.IsDigit(e.KeyChar) || char.IsControl(e.KeyChar))
            {
                e.Handled = false;
            }
            else
            {
                e.Handled = true;
            }
        }

        private void txtName_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (char.IsLetter(e.KeyChar) || char.IsControl(e.KeyChar) || char.IsWhiteSpace(e.KeyChar))
            {
                e.Handled = false;
            }
            else
            {
                e.Handled = true;
            }
        }

        private void txtSalary_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (char.IsDigit(e.KeyChar) || char.IsControl(e.KeyChar))
            {
                e.Handled = false;
            }
            else
            {
                e.Handled = true;
            }
        }
    }
}
