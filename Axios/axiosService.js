import axios from "axios";
import {
  onGlobalSuccess,
  onGlobalError,
  API_HOST_PREFIX,
} from "../services/serviceHelpers";

const baseUrl = API_HOST_PREFIX + "/api/notes";

//Search
const searchNotesBySeeker = (searchQuery, pageIndex, pageSize) => {
  const config = {
    method: "GET",
    url:
      baseUrl +
      `/bysearchingseeker?searchQuery=${searchQuery}&pageIndex=${pageIndex}&pageSize=${pageSize}`,
    withCredentials: true,
    crossdomain: true,
    headers: {
      "Content-Type": "application/json",
    },
  };
  return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

const searchNotesByProvider = (searchQuery, pageIndex, pageSize) => {
  const config = {
    method: "GET",
    url:
      baseUrl +
      `/bysearchingprovider?searchQuery=${searchQuery}&pageIndex=${pageIndex}&pageSize=${pageSize}`,
    withCredentials: true,
    crossdomain: true,
    headers: {
      "Content-Type": "application/json",
    },
  };
  return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};


//Select
const getNotesBySeekerId = (pageIndex, pageSize) => {
  const config = {
    method: "GET",
    url: baseUrl + `/seeker?pageIndex=${pageIndex}&pageSize=${pageSize}`,
    crossdomain: true,
    withCredentials: true,
    headers: { "Content-Type": "application/json" },
  };

  return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

const getNoteById = (id) => {
  const config = {
    method: "GET",
    url: baseUrl + `/${id}`,
    crossdomain: true,
    withCredentials: true,
    headers: { "Content-Type": "application/json" },
  };

  return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};


const getNotesCreatedByProvider = (pageIndex, pageSize) => {
  const config = {
    method: "GET",
    url: baseUrl + `/createdby?pageIndex=${pageIndex}&pageSize=${pageSize}`,
    crossdomain: true,
    withCredentials: true,
    headers: { "Content-Type": "application/json" },
  };

  return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

const getListOfSeekerNames = () => {
  const config = {
    method: "GET",
    url: baseUrl + `/listofseekers`,
    crossdomain: true,
    withCredentials: true,
    headers: { "Content-Type": "application/json" },
  };

  return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

//Insert
const addNote = (payload) => {
  const config = {
    method: "POST",
    url: baseUrl,
    data: payload,
    crossdomain: true,
    withCredentials: true,
    headers: { "Content-Type": "application/json" },
  };

  return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

//Update
const updateNoteById = (payload, id) => {
  const config = {
    method: "PUT",
    url: baseUrl + `/${id}`,
    data: payload,
    crossdomain: true,
    withCredentials: true,
    headers: { "Content-Type": "application/json" },
  };

  return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

//Delete
const deleteNoteById = (id) => {
  const config = {
    method: "DELETE",
    url: baseUrl + `/${id}`,
    crossdomain: true,
    withCredentials: true,
    headers: { "Content-Type": "application/json" },
  };

  return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

export {
  getNoteById,
  getNotesCreatedByProvider,
  addNote,
  updateNoteById,
  deleteNoteById,
  searchNotesBySeeker,
  searchNotesByProvider,
  getNotesBySeekerId,
  getListOfSeekerNames,
};
