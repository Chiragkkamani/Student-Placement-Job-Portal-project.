package com.ajt.portal.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class ApplicationStatusHistory implements Serializable {
    private static final long serialVersionUID = 1L;

    private int historyId;
    private int applicationId;
    private String previousStatus;
    private String newStatus;
    private Integer changedBy;
    private String changedByName;
    private Timestamp changeTimestamp;

    public ApplicationStatusHistory() {
    }

    public ApplicationStatusHistory(int applicationId, String previousStatus, String newStatus, Integer changedBy) {
        this.applicationId = applicationId;
        this.previousStatus = previousStatus;
        this.newStatus = newStatus;
        this.changedBy = changedBy;
    }

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    public String getPreviousStatus() {
        return previousStatus;
    }

    public void setPreviousStatus(String previousStatus) {
        this.previousStatus = previousStatus;
    }

    public String getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }

    public Integer getChangedBy() {
        return changedBy;
    }

    public void setChangedBy(Integer changedBy) {
        this.changedBy = changedBy;
    }

    public String getChangedByName() {
        return changedByName;
    }

    public void setChangedByName(String changedByName) {
        this.changedByName = changedByName;
    }

    public Timestamp getChangeTimestamp() {
        return changeTimestamp;
    }

    public void setChangeTimestamp(Timestamp changeTimestamp) {
        this.changeTimestamp = changeTimestamp;
    }
}

