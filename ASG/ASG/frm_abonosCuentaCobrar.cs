﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.Odbc;

namespace ASG
{
    public partial class frm_abonosCuentaCobrar : Form
    {
        Point DragCursor;
        Point DragForm;
        bool Dragging;
        string numeroCuenta;
        double abonado;
        double totalFactura;
        string rolUsuario;
        bool flag = false;
        string codigoCliente;
        string nombreSucursal;
        string nombreUsuario;
        ContextMenuStrip mymenu = new ContextMenuStrip();
        public frm_abonosCuentaCobrar(string codigo, string nombre, string numero, string emision, string vencimiento, string cuenta, bool  estado, string total, string rol, string sucursal, string usuario)
        {
            InitializeComponent();
            label2.Text = codigo;
            label6.Text = nombre;
            label11.Text = numero;
            label8.Text = emision;
            label10.Text = vencimiento;
            numeroCuenta = cuenta;
            codigoCliente = codigo;
            rolUsuario = rol;
            nombreSucursal = sucursal;
            nombreUsuario = usuario;
            stripMenu();
            numeroCuenta = cuenta;
            totalFactura = Convert.ToDouble(total);
            label15.Text = total;         
            cargaDatos();
            getAbonos();
            setterForm();
            if (rolUsuario != "ADMINISTRADOR")
            {
                button1.Enabled = false;
                mymenu.Items[1].Enabled = false;
            }
            if (estado == true)
            {
                label19.Text = "NO CANCELADO";
                label19.BackColor = Color.OrangeRed;
            }
            else
            {
                label19.Text = "CANCELADO";
                label19.BackColor = Color.Blue;
                button1.Enabled = false;
                //button8.Enabled = false;
            }
        }
        private void stripMenu()
        {
            mymenu.Items.Add("Ocultar Fila");
            mymenu.Items[0].Name = "ColHidden";
            mymenu.Items.Add("Eliminar Abono Cliente");
            mymenu.Items[1].Name = "ColEdit";
           
        }

        private void cargaDatos()
        {
            OdbcConnection conexion = ASG_DB.connectionResult();
            try
            {
                string sql = string.Format("SELECT * FROM VISTA_ABONOS WHERE ID_CUENTA_POR_COBRAR = {0};", numeroCuenta);
                OdbcCommand cmd = new OdbcCommand(sql, conexion);
                OdbcDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    dataGridView1.Rows.Clear();
                    dataGridView1.Rows.Add(reader.GetString(0), reader.GetString(1), reader.GetString(2), string.Format("{0:###,###,###,##0.00##}", reader.GetDouble(3)), string.Format("{0:###,###,###,##0.00##}", reader.GetDouble(4)), string.Format("{0:###,###,###,##0.00##}", reader.GetDouble(5)));
                    while (reader.Read())
                    {
                        dataGridView1.Rows.Add(reader.GetString(0), reader.GetString(1), reader.GetString(2), string.Format("{0:###,###,###,##0.00##}", reader.GetDouble(3)), string.Format("{0:###,###,###,##0.00##}", reader.GetDouble(4)), string.Format("{0:###,###,###,##0.00##}", reader.GetDouble(5)));
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
            conexion.Close();
        }
        private void setterForm()
        {
            double balance = totalFactura - abonado;
            label23.Text = string.Format("{0:###,###,###,##0.00##}", balance);
        }
        private void getAbonos()
        {
            if(dataGridView1.RowCount > 0)
            {
                for (int i = 0; i < dataGridView1.RowCount; i++)
                {
                    abonado = abonado + Convert.ToDouble(dataGridView1.Rows[i].Cells[5].Value.ToString());
                }
                label17.Text = string.Format("{0:###,###,###,##0.00##}", abonado);
            } else
            {
                label17.Text = "0";
            }
            
        }
        private void frm_abonosCuentaCobrar_Load(object sender, EventArgs e)
        {

        }

        private void frm_abonosCuentaCobrar_KeyDown(object sender, KeyEventArgs e)
        {
            if(e.KeyData == Keys.Escape)
            {
                this.Close();
            }
        }

        private void pictureBox3_Click(object sender, EventArgs e)
        {
            DialogResult = DialogResult.OK;
        }

        private void frm_abonosCuentaCobrar_MouseDown(object sender, MouseEventArgs e)
        {
            Dragging = true;
            DragCursor = Cursor.Position;
            DragForm = this.Location;
        }

        private void frm_abonosCuentaCobrar_MouseMove(object sender, MouseEventArgs e)
        {
            if (Dragging == true)
            {
                Point dif = Point.Subtract(Cursor.Position, new Size(DragCursor));
                this.Location = Point.Add(DragForm, new Size(dif));
            }
        }

        private void frm_abonosCuentaCobrar_MouseUp(object sender, MouseEventArgs e)
        {
            Dragging = false;
        }
        private void my_menu_Itemclicked(object sender, ToolStripItemClickedEventArgs e)
        {
            if (flag == false)
            {
                if (e.ClickedItem.Name == "ColHidden")
                {
                    dataGridView1.Rows[this.dataGridView1.CurrentRow.Index].Visible = false;
                    flag = true;
                }
                else if (e.ClickedItem.Name == "ColEdit")
                {
                   
                    mymenu.Visible = false;
                    button1.PerformClick();
                    flag = true;

                }
                
            }
        }
        private void dataGridView1_MouseClick(object sender, MouseEventArgs e)
        {
            if (dataGridView1.RowCount > 0)
            {
                if (e.Button == MouseButtons.Right)
                {
                    mymenu.Show(dataGridView1, new Point(e.X, e.Y));
                    mymenu.ItemClicked += new ToolStripItemClickedEventHandler(my_menu_Itemclicked);
                    mymenu.Enabled = true;
                    flag = false;
                }
            }
        }

        private void button8_Click(object sender, EventArgs e)
        {
            if (dataGridView1.RowCount > 0)
            {
                double cast = Convert.ToDouble(label23.Text);
                //MessageBox.Show("" + cast);
                var forma = new frm_abono(dataGridView1.CurrentRow.Cells[1].Value.ToString(), cast, codigoCliente, true,nombreSucursal,nombreUsuario);
                if (forma.ShowDialog() == DialogResult.OK)
                {
                    cargaDatos();
                    abonado = 0;
                    getAbonos();
                    setterForm();
                    
                }
            }
        }
        private void updateDisponible(string abono)
        {
            OdbcConnection conexion = ASG_DB.connectionResult();
            try
            {
                string sql = string.Format("UPDATE CLIENTE SET CREDITO_DISPONIBLE = CREDITO_DISPONIBLE - {0} WHERE ID_CLIENTE = '{1}';", abono, codigoCliente);
                OdbcCommand cmd = new OdbcCommand(sql, conexion);
                if (cmd.ExecuteNonQuery() == 1)
                {
                    var forma = new frm_creditoActualizado();
                    forma.ShowDialog();
                }
                else
                {
                    MessageBox.Show("IMPOSILE ABONAR PAGO DE CLIETE!", "NUEVA VENTA - CREDITO", MessageBoxButtons.OK, MessageBoxIcon.Error);

                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
            conexion.Close();
        }
        private void updateAbono(string abono)
        {
            OdbcConnection conexion = ASG_DB.connectionResult();
            try
            {
                string sql = string.Format("UPDATE CUENTA_POR_COBRAR_CLIENTE SET TOTAL_PAGADO = TOTAL_PAGADO - {0} WHERE ID_CUENTA_POR_COBRAR = {1};", abono, numeroCuenta);
                OdbcCommand cmd = new OdbcCommand(sql, conexion);
                if (cmd.ExecuteNonQuery() == 1)
                {
                    updateDisponible(abono);
                }
                else
                {
                    MessageBox.Show("IMPOSILE ABONAR PAGO DE CLIETE!", "NUEVA VENTA - CREDITO", MessageBoxButtons.OK, MessageBoxIcon.Error);

                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
            conexion.Close();
        }
        private void eliminaPago(string codigoPago)
        {
            OdbcConnection conexion = ASG_DB.connectionResult();
            try
            {
                string sql = string.Format("UPDATE PAGO_CLIENTE SET ESTADO_TUPLA = FALSE WHERE ID_PAGO = {0};", codigoPago);
                OdbcCommand cmd = new OdbcCommand(sql, conexion);
                if (cmd.ExecuteNonQuery() == 1)
                {
                    updateAbono(dataGridView1.CurrentRow.Cells[5].Value.ToString());
                }
                else
                {
                    MessageBox.Show("IMPOSIBLE ELIMINAR EL ABONO!", "COMPRAS - CREDITO", MessageBoxButtons.OK, MessageBoxIcon.Error);

                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
            conexion.Close();
        }
        private void button1_Click(object sender, EventArgs e)
        {
            if(dataGridView1.RowCount  > 0)
            {

                DialogResult result;
                result = MessageBox.Show("¿ESTA SEGURO QUE DESEA ELIMINAR EL ABONO DEL CLIENTE?", "CUENTAS POR COBRAR", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
                if (result == System.Windows.Forms.DialogResult.Yes)
                {
                    eliminaPago(dataGridView1.CurrentRow.Cells[0].Value.ToString());
                    adressUser.ingresaBitacora(nombreSucursal, nombreUsuario, "ELIMINA PAGO PARCIAL", codigoCliente);
                    cargaDatos();
                    abonado = 0;
                    getAbonos();
                    setterForm();
                }             
            }
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
