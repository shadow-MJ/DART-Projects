import 'dart:io';

// ── Account ──────────────────────────────
class Account {
  String name;
  String pin;
  double balance;

  Account(this.name, this.pin, this.balance);
}

// ── ATM ──────────────────────────────────
class ATM {
  List<Account> accounts = [ ];

  Account? current;

  String input(String label) {
    stdout.write(label);
    return stdin.readLineSync() ?? "";
  }

  void registerUser() {
    print("\n--- CREATE ACCOUNT ---");
    String name = input("Enter your name : ");

    // Check name not already taken
    bool exists = accounts.any((a) => a.name.toLowerCase() == name.toLowerCase());
    if (exists) {
      print("That name is already registered.");
      return;
    }

    String pin     = input("Set a PIN        : ");
    String confirm = input("Confirm PIN      : ");
    if (pin != confirm) {
      print("PIN is do not match. Try again.");
      return;
    }

    double? deposit = double.tryParse(input("Initial deposit  : \$"));
    if (deposit == null || deposit < 0) {
      print("Invalid amount.");
      return;
    }

    accounts.add(Account(name, pin, deposit));
    print("Account created! Welcome, $name. You can now login.");
  }

  void login() {
    print("\n--- LOGIN ---");
    String name = input("Name : ");
    String pin  = input("PIN  : ");

    try {
      current = accounts.firstWhere(
            (a) => a.name.toLowerCase() == name.toLowerCase() && a.pin == pin,
      );
    } catch (_) {
      print("Wrong name or PIN.");
      return;
    }

    print("Welcome, ${current!.name}!");

    // MENU LOOP
    while (true) {
      print("\n--- MENU ---");
      print("1. Check Balance");
      print("2. Deposit");
      print("3. Withdraw");
      print("4. Logout");
      String choice = input("Choose: ");

      if (choice == "1") {
        print("Balance: \$${current!.balance}");

      } else if (choice == "2") {
        double? amt = double.tryParse(input("Deposit amount: \$"));
        if (amt == null || amt <= 0) { print("Invalid amount."); continue; }
        current!.balance += amt;
        print("Deposited. New balance: \$${current!.balance}");

      } else if (choice == "3") {
        double? amt = double.tryParse(input("Withdraw amount: \$"));
        if (amt == null || amt <= 0) { print("Invalid amount."); continue; }
        if (amt > current!.balance) { print("Not enough balance."); continue; }
        current!.balance -= amt;
        print("Withdrawn. New balance: \$${current!.balance}");

      } else if (choice == "4") {
        print("Logged out. Goodbye, ${current!.name}!");
        current = null;
        break;

      } else {
        print("Enter 1, 2, 3, or 4.");
      }
    }
  }

  void run() {
    print("\n===== ATM MACHINE =====");

    while (true) {
      print("\n1. Login");
      print("2. Create New Account");
      print("3. Exit");
      String choice = input("Choose: ");

      if (choice == "1") {
        login();
      } else if (choice == "2") {
        registerUser();
      } else if (choice == "3") {
        print("Thank you. Goodbye!");
        break;
      } else {
        print("Enter 1, 2, or 3.");
      }
    }
  }
}

void main() {
  ATM().run();
}