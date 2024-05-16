from tkinter import ttk
from datetime import date, timedelta
import ttkbootstrap as tb
import pyodbc
import re
import tkintermapview

from ttkbootstrap.constants import *
from ttkbootstrap.dialogs import Messagebox
from ttkbootstrap.tableview import Tableview
from PIL import Image, ImageTk

class Management:
    def __init__(self, root):
        self.window = root
        self.window.title("Drilling Management Studio")
        self.window.geometry("1200x900")

        # configuration
        self.driver = [x for x in pyodbc.drivers() if x.endswith('SQL Server')]
        self.server = 'tcp:dbmanage.lab.ii.agh.edu.pl'
        self.database = 'u_dojurkow'

        self.username = '' #'u_dojurkow'
        self.password = '' 
        self.phone_pattern = re.compile(r"^\d{3}-\d{3}-\d{3}$")

        # top frame
        self.top_frame = tb.Frame(self.window)
        self.top_frame.pack(fill=X)
        # configure grid
        self.top_frame.columnconfigure(0, weight=1)
        self.top_frame.columnconfigure(1, weight=1)

        # frames inside top frame
        self.top_frame_buttons = tb.Frame(self.top_frame)
        self.top_frame_buttons.grid(row=0, column=0, sticky=W)

        self.top_frame_info = tb.Label(self.top_frame, text="Zaloguj się do bazy danych", font=('Lato', 12),
                                       bootstyle='warning')
        self.top_frame_info.grid(row=0, column=1, padx=5, pady=5, sticky=W)

        self.top_frame_label = tb.Label(self.top_frame, text="DrillingManagementStudio", font=('lato', 20))
        self.top_frame_label.grid(row=0, column=2, padx=5, pady=5, sticky=E)

        # top frame buttons
        self.connect_button = tb.Button(self.top_frame_buttons, text="Połącz", command=self.connect, bootstyle='success-link', takefocus=1)
        self.connect_button.grid(row=0, column=0, padx=5, pady=5)
        self.employee_button = tb.Menubutton(self.top_frame_buttons, text="Ludzie", bootstyle='success, outline', takefocus=1)
        self.employee_button.grid(row=0, column=1, padx=5, pady=5)
        self.rigs_button = tb.Menubutton(self.top_frame_buttons, text="Sprzęt", bootstyle='success, outline', takefocus=1)
        self.rigs_button.grid(row=0, column=2, padx=5, pady=5)
        self.work_button = tb.Menubutton(self.top_frame_buttons, text="Produkcja", bootstyle='success, outline', takefocus=1)
        self.work_button.grid(row=0, column=3, padx=5, pady=5)

        # localization
        self.employee_button.grid(row=0, column=1, padx=5, pady=5)
        
        # menus
        # menu employee_button
        self.employee_button_menu = tb.Menu(self.employee_button)
        self.employee_button_menu.add_command(label="Przeglądaj", font=('lato', 10), command=self.employees)
        self.employee_button_menu.add_command(label="Obecność", font=('lato', 10), command=self.attendance_view)
        self.employee_button_menu.add_command(label="Brygady", font=('lato', 10), command=self.teams_view)
        # setting menu to menu button
        self.employee_button['menu'] = self.employee_button_menu

        # menu work_button
        self.work_button_menu = tb.Menu(self.work_button)
        self.work_button_menu.add_command(label='Przeglądaj', font=('lato', 10), command=self.theory_view)
        self.work_button_menu.add_command(label='Dodaj', font=('lato', 10), command=self.insert_work_view)
        self.work_button_menu.add_command(label='Raporty', font=('lato', 10), command=self.work_reports_view)
        # setting menu to work_button
        self.work_button['menu'] = self.work_button_menu

        # separator
        self.sep = tb.Separator(root, orient=HORIZONTAL, bootstyle='success')
        self.sep.pack(fill=X, padx=10)

        # main_frame
        self.main_frame = tb.Frame(self.window,  bootstyle='secondary')
        self.main_frame.pack(fill=BOTH, expand=1)

        # frame inside main_frame
        self.label_frame_in = tb.Frame(self.main_frame, height=50)
        self.tab_frame_in = tb.Frame(self.main_frame, height=150)
        self.entry_frame_in = tb.Frame(self.main_frame, height=50)
        self.info_frame_in = tb.Frame(self.main_frame, height=10, bootstyle='secondary')

        # lokalize inside frame
        self.label_frame_in.pack(fill=BOTH, expand=0)
        self.tab_frame_in.pack(fill=BOTH, expand=1)
        self.entry_frame_in.pack(fill=BOTH, expand=1)
        self.info_frame_in.pack(fill=BOTH, expand=1)

        # info frame label
        self.report = tb.Label(self.info_frame_in, text='', font=('Lato', 15))
        self.report.pack(fill=BOTH, expand=1, ipadx=10, ipady=10)

        # map icons
        self.star = ImageTk.PhotoImage(Image.open('gwiaz.png').resize((15, 15)))
        self.star_done = ImageTk.PhotoImage(Image.open('gwiaz_done.png').resize((12, 12)))
        self.circle = ImageTk.PhotoImage(Image.open('kolko.png').resize((15, 15)))


    def employees_view(self, event):
        '''manage combobox positons_combo and show employees list'''
        self.clear_screen(self.tab_frame_in)

        choice = self.positions_combo.get()

        if choice == 'Wszyscy':
            qra = 'select * from VW_Drillers'
        elif choice == 'Brygadziści':
            qra = 'select * from VW_Drillers where id = id_brygadzisty'
        else:
            qra = f"select * from VW_Drillers where Stanowisko = '{choice}';"

        employees_chosen = self.cur.execute(qra).fetchall()
        header = [column[0] for column in self.cur.description]

        # show table with data
        employees_tab = Tableview(
            master=self.tab_frame_in,
            coldata=header,
            rowdata=employees_chosen,
            paginated=False,
            searchable=True,
            autofit=True,
            bootstyle='success')
        employees_tab.pack(fill=BOTH, expand=1, padx=5, pady=5)

    def employees(self):
        ''' Function to display the employees list '''
        self.clear_screen(self.tab_frame_in)
        self.clear_screen(self.entry_frame_in)
        self.clear_screen(self.label_frame_in)
        employee_view_label = tb.Label(self.label_frame_in, text='Pracownicy: ', font=('Lato', 12))
        employee_view_label.grid(row=0, column=0, columnspan=2, sticky=W, padx=10, pady=10)
        self.report.config(text='', bootstyle='success')

        # positions in database
        self.positions = ['Wszyscy', 'Brygadziści']
        self.positions_in_table = []
        self.positions_in_table = [i[0] for i in self.cur.execute("select position from positions order by id").fetchall()]
        self.positions += self.positions_in_table

        # combobox for positions
        self.positions_combo = tb.Combobox(self.label_frame_in, values=self.positions, bootstyle='success')
        self.positions_combo.grid(row=0, column=3, columnspan=2, padx=10, pady=10)
        self.positions_combo.current(0)
        self.positions_combo.bind("<<ComboboxSelected>>", self.employees_view)

        # entry frame
        self.entry_frame_1()

    def entry_frame_1(self):
        '''frame for entry data in employees site'''

        entry_frame = tb.LabelFrame(self.entry_frame_in, text="Aktualizacja danych", bootstyle='warning')
        entry_frame.pack(fill=BOTH, expand=1, ipadx=5, ipady=5)

        # register validation function
        empt_field = self.entry_frame_in.register(lambda x: bool(x)) # check if entry field is empty
        phone_field = self.entry_frame_in.register(lambda x: bool(self.phone_pattern.match(x)) if x else True)

        # entry fields
        firstname_label = tb.Label(entry_frame, text="Imię:*", font=('Lato', 10))
        firstname_label.grid(row=0, column=0, padx=15, pady=5)
        self.firstname_entry = tb.Entry(entry_frame, justify=CENTER, width=22, font=('Lato', 10), bootstyle='success',
                                   validate='focus', validatecommand=(empt_field, "%P"))
        self.firstname_entry.grid(row=0, column=1)

        lastname_label = tb.Label(entry_frame, text='Nazwisko:*', font=('Lato', 10))
        lastname_label.grid(row=0, column=2, padx=15, pady=5)
        self.lastname_entry = tb.Entry(entry_frame, justify=CENTER, width=22, font=('Lato', 10), bootstyle='success',
                                       validate='focus', validatecommand=(empt_field, "%P"))
        self.lastname_entry.grid(row=0, column=3, padx=5)

        phone_label = tb.Label(entry_frame, text="Telefon:", font=('Lato', 10))
        phone_label.grid(row=1, column=0, padx=15, pady=5)
        self.phone_entry = tb.Entry(entry_frame, justify=CENTER, width=22, bootstyle='success', font=('Lato', 10),
                                    validate='focus', validatecommand=(phone_field, "%P"))
        self.phone_entry.grid(row=1, column=1, padx=5, pady=5)

        position_label = tb.Label(entry_frame, text="Stanowisko:*", font=('Lato', 10))
        position_label.grid(row=1, column=2, padx=15, pady=5)
        self.position_get = tb.Combobox(entry_frame, bootstyle='success', values=self.positions_in_table, width=20,
                                        font=('Lato', 10), validate='focus', validatecommand=(empt_field, "%P"))
        self.position_get.grid(row=1, column=3, padx=5, pady=5)

        # buttons
        add_button = tb.Button(entry_frame, text='Dodaj', width=20, command=self.add_employee, bootstyle='success')
        add_button.grid(row=2, column=0, padx=5, pady=5)

        edit_button = tb.Button(entry_frame, text='Zmień', width=20, command=self.edit_employee, bootstyle='warning')
        edit_button.grid(row=2, column=1, padx=5, pady=5)

        remove_button = tb.Button(entry_frame, text='Usuń', width=20, command=self.remove_employee, bootstyle='danger')
        remove_button.grid(row=2, column=2, padx=5, pady=5)

    def add_employee(self):
        ''' Function to add a new employee '''
        v_firstname = self.firstname_entry.get().strip().capitalize()
        v_lastname = self.lastname_entry.get().strip().capitalize()
        v_phone = self.phone_entry.get()
        v_position = self.position_get.get()


        if not v_position or not v_firstname or not v_lastname:
            self.report.config(text='Pola: imię, nazwisko i stanowisko muszą być wypełnione.', bootstyle='danger')
        elif v_phone and not self.phone_pattern.match(v_phone):
            self.report.config(text="Podaj numer telefonu w formacie '123-456-789'", bootstyle='danger')
        else:
            # check if exists employee with this firstname and lastname.
            check = self.cur.execute(f"select * from VW_contacts "
                                     f"where first_name = '{v_firstname}'"
                                     f"and last_name = '{v_lastname}'").fetchone()
            selected_position = self.cur.execute(f"select id from positions "
                                                 f"where position = '{v_position}'").fetchone()[0]

            if check:
                self.report.config(text='Istnieje już pracownik o podanym imieniu i nazwisku', bootstyle='warning')

                # message box for manage existing same name in database
                mb = Messagebox.show_question('Istnnieje już pracownik o takim samym imieniu i nazwisku.'
                                              '\n Chesz dodać ponownie?','Uwaga',
                                              buttons=['Nie dodawaj: pirmary', 'Mimo to dodaj: danger'])
                if mb == 'Mimo to dodaj':
                   # selected_position = self.cur.execute(f"select id from positions "
                   #                                      f"where position = '{v_position}'").fetchone()[0]
                    if v_phone:
                        add_qra = f"exec p_add_driller {v_firstname}, {v_lastname}, {selected_position}, '{v_phone}'"
                    else:
                        add_qra = f"exec p_add_driller {v_firstname}, {v_lastname}, {selected_position}"
                    self.cur.execute(add_qra)
                    self.cur.commit()
            else:
                if v_phone:
                    add_qra = f"exec p_add_driller {v_firstname}, {v_lastname}, {selected_position}, '{v_phone}'"
                else:
                    add_qra = f"exec p_add_driller {v_firstname}, {v_lastname}, {selected_position}"
                self.cur.execute(add_qra)
                self.cur.commit()


    def edit_employee(self):
        ''' Function to edit an existing employee (phone, position)'''
        # constant, not edited:
        v_firstname = self.firstname_entry.get().strip().capitalize()
        v_lastname = self.lastname_entry.get().strip().capitalize()
        # edited fields:
        v_phone = self.phone_entry.get()
        v_position = self.position_get.get()

        employee_id = self.cur.execute(f"select id from drillers "
                                       f"where first_name ='{v_firstname}' "
                                       f"and last_name = '{v_lastname}'").fetchone()

        if not employee_id:
            self.report.config(text=f'Pracownika {v_firstname} {v_lastname} nie ma w bazie.\n'
                                    f'Jeśli chcesz go dodać, użyj przycisku "dodaj"', bootstyle='warning')
        else:
            self.report.config(bootstyle='success')
            report_text = f'ID pracownika {v_firstname} {v_lastname}: {employee_id[0]}\n'

            if v_phone:
                if not self.phone_pattern.match(v_phone):
                    report_text += "Podaj numer telefonu w formacie '123-456-789'\n"
                    self.report.config(bootstyle='warning')
                else:
                    report_text += f'Nowy numer telefonu to {v_phone}\n'
                    self.cur.execute(f"update contacts set phone ='{v_phone}' where id = {employee_id[0]}")

            if v_position:
                try:
                    position_id = self.cur.execute(f"select id from positions where position = '{v_position}'").fetchone()
                    self.cur.execute(f"exec p_update_driller_position  {employee_id[0]}, {position_id[0]}")
                    report_text += f'Nowe stanowisko to {v_position}\n'
                except pyodbc.Error as error:
                    report_text += 'Pozycja niezmieniona\n'
            else:
                report_text += 'Pozycja niezmieniona\n'

            self.report.config(text=report_text)
        # need manage case that exists more than one worker with the same name - for later

    def remove_employee(self):
        ''' Function to remove an existing employee'''
        self.report.config(text=f'Funkcja niedostępna.', bootstyle='warning')

    def attendance_view(self):
        ''' Function to display the attendance report '''

        self.clear_screen(self.tab_frame_in)
        self.clear_screen(self.entry_frame_in)
        self.clear_screen(self.label_frame_in)
        attendance_view_label = tb.Label(self.label_frame_in, text='Obecność: ', font=('Lato', 12))
        attendance_view_label.grid(row=0, column=0, columnspan=2, sticky=W, padx=10, pady=10)
        self.report.config(text='', bootstyle='success')

        # attendance data
        attendance_list = self.cur.execute(f"select * from VW_attendance_report3 order by driller_id;").fetchall()
        attendance_header = [column[0] for column in self.cur.description]


        # show table with attendance in current month
        attendance_tab = Tableview(
            master=self.tab_frame_in,
            coldata=attendance_header,
            rowdata=attendance_list,
            paginated=False,
            searchable=True,
            autofit=True,
            bootstyle='success')
        attendance_tab.pack(fill=BOTH, expand=1, padx=5, pady=5)

        self.attendance_label_frame = tb.LabelFrame(self.entry_frame_in, text='Obecność')
        self.attendance_label_frame.pack(fill=BOTH, expand=1, padx=5)
        self.check_attendance()
        self.button_attendance()

    def check_attendance(self):
        attendance_employees = self.cur.execute('Select id, driller from vw_drillers order by id;').fetchall()
        self.attendance_dict = {}

        print(attendance_employees)
        for i in attendance_employees:
            print(i)
            self.attendance_dict[i[0]] = 1
            self.attendance_checkbox(i)
        print(self.attendance_dict)

    def attendance_checkbox(self, employee):
        checkbox_var = tb.IntVar(value=1)
        checkbox = tb.Checkbutton(self.attendance_label_frame, text=f'{employee[0]} {employee[1]}', variable=checkbox_var,
                                  command=lambda v=employee: self.on_checkbox_change_updater(v, checkbox_var))
        checkbox.pack(padx=10, anchor=W)

    def on_checkbox_change_updater(self, variable, value):
        '''function to update attendance dictionary'''
        print(f'pracownik {variable} jest {value.get()}')
        self.attendance_dict[variable[0]] = value.get()


    def button_attendance(self):
        self.in_date = tb.DateEntry(self.attendance_label_frame, bootstyle='success', dateformat='%Y-%m-%d', width=10)
        # dateformat - independence from system settings
        attendace_button = tb.Button(self.attendance_label_frame, text='Wprowadź obecność', command=self.attendance_insert,
                                     bootstyle='success')
        self.in_date.pack(padx=10, pady=5, side=LEFT)
        attendace_button.pack(padx=10, pady=5, side=LEFT)

    def attendance_insert(self):
        '''insert attendance into the database'''
        date_in = self.in_date.entry.get()
        y, m, d = self.in_date.entry.get().split(sep='-')
        date_in = date(int(y), int(m), int(d))
        if date_in > date.today():
            mb = Messagebox.show_error('Podaj prawidłową datę!')
            print('Wprowadź prawidłową datę!')
        else:
            print(f'wybrana data: {date_in}')
            print(self.attendance_dict)
            attendance_list = []
            for key, value in self.attendance_dict.items():
                attendance_list.append((key, date_in.strftime('%Y-%m-%d'), value))
            print(attendance_list)
            self.cur.executemany('insert into attendance (driller_id, date, is_present) VALUES (?,?,?)', attendance_list)
            self.con.commit()


    def teams_view(self):
        ''' Function to display the teams '''
        self.clear_screen(self.label_frame_in)
        self.employee_view_label = tb.Label(self.label_frame_in, text='Zespoły: Funkcja niedostępna', font=('Lato', 12))
        self.employee_view_label.grid(row=0, column=0, columnspan=2, sticky=W, padx=10, pady=10)
        self.clear_screen(self.tab_frame_in)
        self.clear_screen(self.entry_frame_in)
        self.report.config(text='', bootstyle='success')


    def choose_map_server(self, event):
        '''function to change map tiling server'''
        new_map = self.map_option_combo.get()
        if new_map == "OpenStreetMap":
            self.map_widget.set_tile_server("https://a.tile.openstreetmap.org/{z}/{x}/{y}.png")
        elif new_map == "Google normal":
            self.map_widget.set_tile_server("https://mt0.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}&s=Ga", max_zoom=22)
        elif new_map == "Google satellite":
            self.map_widget.set_tile_server("https://mt0.google.com/vt/lyrs=s&hl=en&x={x}&y={y}&z={z}&s=Ga", max_zoom=22)


    def theory_view(self):
        '''Display theory when select theory from menu work_menu'''
        self.clear_screen(self.tab_frame_in)
        self.clear_screen(self.entry_frame_in)
        self.clear_screen(self.label_frame_in)
        theory_view_label = tb.Label(self.label_frame_in, text='Przegląd punktów: ', font=('Lato', 12))
        theory_view_label.pack(side=LEFT, padx=10, pady=10)
        self.report.config(text='', bootstyle='success')

        # select tile server:
        self.map_option_combo = tb.Combobox(self.label_frame_in, bootstyle='success',
                                            values=["OpenStreetMap", "Google normal", "Google satellite"])
        self.map_option_combo.pack(padx=10, pady=10, side=RIGHT)
        self.map_option_combo.current(0)
        self.map_option_combo.bind("<<ComboboxSelected>>", self.choose_map_server)

        self.map_label = tb.Label(self.label_frame_in, text="Wybierz serwer mapowy:", anchor="w", font=('lato', 12))
        self.map_label.pack(padx=10, pady=10, side=RIGHT)

        min_lat, max_lat, min_long, max_long = self.cur.execute('select * from vw_map_range').fetchone()
        print(min_lat, max_lat, min_long, max_long)
        # create map widged in tab_frame_in
        self.map_widget = tkintermapview.TkinterMapView(self.tab_frame_in, height=450)
        self.map_widget.pack(fill=BOTH, expand=1, padx=5, pady=5)
        self.map_widget.fit_bounding_box((max_lat, min_long), (min_lat, max_long))

        # tab with all points in database

        theory_all = self.cur.execute('Select * from vw_theory where drilling_date is null').fetchall()
        header = [column[0] for column in self.cur.description]

        theory_tab = Tableview(
            master=self.entry_frame_in,
            coldata=header,
            rowdata=theory_all,
            paginated=True,
            searchable=True,
            autofit=True,
            bootstyle='success')
        theory_tab.pack(fill=BOTH, expand=1, padx=5, pady=5)


        #show points on map
        theory_map = self.cur.execute('select * from vw_theory').fetchall()
        for row in theory_map:
            if row[1].strip() == 'xt' or row[1].strip() == 'xr':
                if row[5]:
                    self.map_widget.set_marker(row[2], row[3], text=str(row[0]), icon=self.star_done,
                                               text_color='grey')
                else:
                    self.map_widget.set_marker(row[2], row[3], text=str(row[0]), icon=self.star)
            else:
                self.map_widget.set_marker(row[2], row[3], text=str(row[0]), icon=self.circle)




    def insert_work_view(self):
        '''Display window to insert daily work to database'''
        self.clear_screen(self.tab_frame_in)
        self.clear_screen(self.entry_frame_in)
        self.clear_screen(self.label_frame_in)
        insert_work_view_label = tb.Label(self.label_frame_in, text='Wprowadź dane: ', font=('Lato', 12))
        insert_work_view_label.grid(row=0, column=0, columnspan=2, sticky=W, padx=10, pady=10)
        self.report.config(text='', bootstyle='success')

    def work_reports_view(self):
        '''Display window with production, work reports'''
        self.clear_screen(self.label_frame_in)
        self.employee_view_label = tb.Label(self.label_frame_in, text='Raporty: Funkcja niedostępna', font=('Lato', 12))
        self.employee_view_label.grid(row=0, column=0, columnspan=2, sticky=W, padx=10, pady=10)
        self.clear_screen(self.tab_frame_in)
        self.clear_screen(self.entry_frame_in)
        self.report.config(text='', bootstyle='success')









    def connect(self):
        self.connect_window = tb.Toplevel(self.window)
        self.connect_window.title("Logowanie")
        self.connect_window.geometry("400x200")

        # labels and entries
        self.user_label = tb.Label(self.connect_window, text="Username: ", font=('lato', 12)).grid(row=0, column=0, padx=5, pady=5)
        self.user_entry = tb.Entry(self.connect_window, font=('lato', 12), justify="center", width=20)

        self.pass_label = tb.Label(self.connect_window, text="Password: ", font=('lato', 12)).grid(row=1, column=0, padx=5, pady=5)
        self.pass_entry = tb.Entry(self.connect_window, font=('lato', 12), justify="center", width=20, show='*')

        self.log_button = tb.Button(self.connect_window, text='Zaloguj', width=20)
        self.log_button.bind('<Button-1>', self.connect_database)

        self.user_entry.grid(row=0, column=1, padx=5, pady=5)
        self.pass_entry.grid(row=1, column=1, padx=5, pady=5)
        self.log_button.grid(row=2, column=0, columnspan=2, padx=5, pady=5)

    def connect_database(self, event):
        self.username = self.user_entry.get()
        self.password = self.pass_entry.get()
        self.connect_window.destroy()

        #logowanie
        for i in self.driver:
            self.constr = f"DRIVER={i};SERVER={self.server}; DATABASE={self.database}; UID={self.username};PWD={self.password}; TrustServerCertificate=Yes; autocommit=True"
            try:
                self.con = pyodbc.connect(self.constr)
                self.cur = self.con.cursor()
                Messagebox.show_info(title='Odpowiedź', message='Zalogowano się do bazy danych')
                self.top_frame_info.destroy()
                print('Success')
                break
            except pyodbc.InterfaceError:
                Messagebox.show_info(title='Odpowiedź', message='Błędny login lub hasło')
                print('Błąd logowania')
                break
            except pyodbc.OperationalError as e:
                Messagebox.show_info(title='Odpowiedź', message=f'Błąd servera.\n{e}')
                print('Błąd serwera')
            except pyodbc.Error:
                print('Bląd sterownika')
                continue


    def clear_screen(self, container):
        '''
        Clears content of the container
        :param container:
        '''
        for widget in container.winfo_children():
            widget.destroy()


# The main function, start the program.
if __name__ == "__main__":
    root = tb.Window(themename='darkly')
    obj = Management(root)
    root.mainloop()
