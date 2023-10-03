import 'package:wedease/consts/consts.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentUser = auth.currentUser;

// Collections
const userCollection = 'users';

// productCollection as serviceCollection

const serviceCollection = "services";
const vendorCollection = "seller_vendors";

// saved collection
const saveCollection = 'saved';

const chatsCollection = 'chats';
const messagesCollection = 'messages';
