package com.example.firstflutter.database;

import android.content.Context;

import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;

import com.example.firstflutter.dao.ContactDao;
import com.example.firstflutter.model.Contact;

@Database(entities = Contact.class, version = 1,exportSchema = false)
public abstract class ContactDatabase extends RoomDatabase {
    public abstract ContactDao contactDao();

    private static volatile ContactDatabase INSTANCE;

    public static ContactDatabase getDatabase(final Context context) {
        if (INSTANCE == null) {
            synchronized (ContactDatabase.class) {

                if (INSTANCE == null) {
                    INSTANCE = Room.databaseBuilder(context.getApplicationContext(),
                            ContactDatabase.class, "contact_database")
                            .allowMainThreadQueries()
                            .fallbackToDestructiveMigration()
                            .build();
                }

            }
        }
        return INSTANCE;
    }

}