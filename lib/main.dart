import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/hotel.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Luxury Hotel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';

  void _login() {
    if (_usernameController.text == 'admin' &&
        _passwordController.text == 'admin') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      setState(() {
        errorMessage = 'Username or Password is incorrect';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> bookings = [];

  void _addBooking(Map<String, String> booking) {
    setState(() {
      bookings.add(booking);
    });
  }

  void _editBooking(int index, Map<String, String> updatedBooking) {
    setState(() {
      bookings[index] = updatedBooking;
    });
  }

  void _deleteBooking(int index) {
    setState(() {
      bookings.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Luxury Hotel'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.hotel),
            title: Text('Our Rooms'),
            subtitle: Text('View and book our luxury rooms'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomsPage(onRoomBooked: _addBooking),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About Us'),
            subtitle: Text('Learn more about our hotel'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('My Bookings'),
            subtitle: Text('View your bookings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingListPage(
                    bookings: bookings,
                    onEditBooking: _editBooking,
                    onDeleteBooking: _deleteBooking,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class RoomsPage extends StatelessWidget {
  final List<Map<String, String>> rooms = [
    {
      'name': 'Deluxe Room',
      'price': 'Rp 1.500.000 / night',
      'image': 'assets/kasur.jpg',
    },
    {
      'name': 'Suite Room',
      'price': 'Rp 2.500.000 / night',
      'image': 'assets/kasur.jpg',
    },
    {
      'name': 'Standard Room',
      'price': 'Rp 1.000.000 / night',
      'image': 'assets/kasur.jpg',
    },
  ];

  final Function(Map<String, String>) onRoomBooked;

  RoomsPage({required this.onRoomBooked});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Rooms'),
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Image.asset(rooms[index]['image']!),
                ListTile(
                  title: Text(rooms[index]['name']!),
                  subtitle: Text(rooms[index]['price']!),
                  trailing: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return BookingDetailsDialog(
                            roomDetails: rooms[index],
                            onBookingConfirmed: (customerDetails) {
                              onRoomBooked({
                                ...rooms[index],
                                ...customerDetails,
                              });
                            },
                          );
                        },
                      );
                    },
                    child: Text('Book Now'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BookingDetailsDialog extends StatefulWidget {
  final Map<String, String> roomDetails;
  final Function(Map<String, String>) onBookingConfirmed;

  BookingDetailsDialog(
      {required this.roomDetails, required this.onBookingConfirmed});

  @override
  _BookingDetailsDialogState createState() => _BookingDetailsDialogState();
}

class _BookingDetailsDialogState extends State<BookingDetailsDialog> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();
  final TextEditingController _customerEmailController =
      TextEditingController();
  final TextEditingController _checkInDateController = TextEditingController();
  final TextEditingController _checkOutDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Booking Details'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _customerNameController,
              decoration: InputDecoration(labelText: 'Customer Name'),
            ),
            TextField(
              controller: _customerPhoneController,
              decoration: InputDecoration(labelText: 'Customer Phone'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _customerEmailController,
              decoration: InputDecoration(labelText: 'Customer Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _checkInDateController,
              decoration: InputDecoration(labelText: 'Check-in Date'),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: _checkOutDateController,
              decoration: InputDecoration(labelText: 'Check-out Date'),
              keyboardType: TextInputType.datetime,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onBookingConfirmed({
              'customerName': _customerNameController.text,
              'customerPhone': _customerPhoneController.text,
              'customerEmail': _customerEmailController.text,
              'checkInDate': _checkInDateController.text,
              'checkOutDate': _checkOutDateController.text,
            });
            Navigator.of(context).pop();
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}

class BookingListPage extends StatelessWidget {
  final List<Map<String, String>> bookings;
  final Function(int, Map<String, String>) onEditBooking;
  final Function(int) onDeleteBooking;

  BookingListPage({
    required this.bookings,
    required this.onEditBooking,
    required this.onDeleteBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: bookings.isEmpty
          ? Center(
              child: Text('No bookings yet!'),
            )
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Image.asset(bookings[index]['image']!),
                    title: Text(bookings[index]['name']!),
                    subtitle: Text(
                        '${bookings[index]['customerName']} - ${bookings[index]['customerPhone']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditBookingPage(
                                  booking: bookings[index],
                                  onSave: (updatedBooking) {
                                    onEditBooking(index, updatedBooking);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => onDeleteBooking(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class EditBookingPage extends StatefulWidget {
  final Map<String, String> booking;
  final Function(Map<String, String>) onSave;

  EditBookingPage({required this.booking, required this.onSave});

  @override
  _EditBookingPageState createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _checkInDateController;
  late TextEditingController _checkOutDateController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.booking['customerName']);
    _phoneController =
        TextEditingController(text: widget.booking['customerPhone']);
    _emailController =
        TextEditingController(text: widget.booking['customerEmail']);
    _checkInDateController =
        TextEditingController(text: widget.booking['checkInDate']);
    _checkOutDateController =
        TextEditingController(text: widget.booking['checkOutDate']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Customer Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Customer Phone'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Customer Email'),
            ),
            TextField(
              controller: _checkInDateController,
              decoration: InputDecoration(labelText: 'Check-in Date'),
            ),
            TextField(
              controller: _checkOutDateController,
              decoration: InputDecoration(labelText: 'Check-out Date'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onSave({
                  ...widget.booking,
                  'customerName': _nameController.text,
                  'customerPhone': _phoneController.text,
                  'customerEmail': _emailController.text,
                  'checkInDate': _checkInDateController.text,
                  'checkOutDate': _checkOutDateController.text,
                });
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Welcome to Luxury Hotel, the finest place to stay for both leisure and business. Our facilities include world-class dining, a spa, swimming pool, and luxurious rooms. We are dedicated to providing the best service for all our guests.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.account_circle, size: 100),
            SizedBox(height: 20),
            Text(
              'Admin',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Email: admin@luxuryhotel.com'),
          ],
        ),
      ),
    );
  }
}
