package com.example.firstflutter.dao;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.SkipQueryVerification;

import com.example.firstflutter.model.Contact;

import java.util.List;

@Dao
public interface ContactDao {

    @Insert
    void createContact(Contact contact);

    @Query("DELETE from Contact")
    void deleteAll();

    @Query("SELECT * FROM Contact ORDER BY firstName Asc")
    List<Contact> listContacts();

    @Query("DELETE FROM Contact where id = :id")
    void deleteById(Long id);


}
