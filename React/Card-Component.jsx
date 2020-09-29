import React from "react";
import PropTypes from "prop-types";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faEdit, faTrashAlt } from "@fortawesome/free-solid-svg-icons";
import * as moment from "moment";
import { PDFDownloadLink } from "@react-pdf/renderer";
import NoteDetailPDF from "./NoteDetailPDF";
import "./Notes.css";

const NoteCard = (props) => {

// Click Handlers
  const editButtonSelected = () => {
    props.onClickEdit(props.item);
  };

  const deleteButtonSelected = () => {
    props.onClickDelete(props.item);
  };

  const handleClick = () => {
    props.onHandleRead(props.item);
  };

  //Preview of Full Note
  const viewContent = (content) => {
    return <div dangerouslySetInnerHTML={{ __html: content }} />;
  };

  //Download pdf component
  const ActionButtons = () => {
    if (props.isProvider === true) {
      return (
        <div className="button-wrapper justify-content-between d-flex">
          <button
            type="button"
            className="btn btn-secondary"
            onClick={editButtonSelected}
            name={props.item.id}
          >
            {<FontAwesomeIcon icon={faEdit} size="sm" />}
          </button>
          <button type="button" className="btn btn-primary">
            <PDFDownloadLink
              document={<NoteDetailPDF pdfData={props.item} />}
              fileName={`Note_Details_ID_${props.item.id}`}
              style={{
                padding: "10px",
                color: "#ffffff",
              }}
            >
              Download PDF{" "}
              {({ loading }) =>
                loading ? "Loading document..." : `Download PDF`
              }
            </PDFDownloadLink>
          </button>
          <button
            type="button"
            className="btn btn-danger"
            onClick={deleteButtonSelected}
            name={props.item.id}
          >
            {<FontAwesomeIcon icon={faTrashAlt} size="sm" />}
          </button>
        </div>
      );
    } else {
      return null;
    }
  };

  return (
    <React.Fragment key={props.item.id}>
      <div className="col-sm-4 col-xs-4 col-md-4 col-lg-4 d-flex align-items">
        <div className="card mt-3 d-flex flex-column" id="note-card">
          <div className="card-body text-center" onClick={handleClick}>
            <h4 className="card-title col-12">
              {`${props.item.userInfo.firstName} ${props.item.userInfo.lastName}`}
            </h4>
            <div className="text">
              <div
                className="card-text text-left text-truncate"
                style={{ textoveflow: "ellipsis", height: "7rem" }}
              >
                {viewContent(props.item.notes)}
              </div>
            </div>
          </div>
          <small className="text-muted text-center">
            Created: {moment(props.item.dateCreated).format("MM-DD-YYYY")}
          </small>
          <div className="card-footer">
            <ActionButtons />
            {props.isProvider !== true && (
              <div className="text-center">
                <button type="button" className="btn btn-primary">
                  <PDFDownloadLink
                    document={<NoteDetailPDF pdfData={props.item} />}
                    fileName={`Note_Details_ID_${props.item.id}`}
                    style={{
                      padding: "10px",
                      color: "#ffffff",
                    }}
                  >
                    Download PDF{" "}
                    {({ loading }) =>
                      loading ? "Loading document..." : `Download PDF`
                    }
                  </PDFDownloadLink>
                </button>
              </div>
            )}
          </div>
        </div>
      </div>
    </React.Fragment>
  );
};

NoteCard.propTypes = {
  item: PropTypes.shape({
    id: PropTypes.number.isRequired,
    notes: PropTypes.string,
    dateCreated: PropTypes.string.isRequired,
    userInfo: PropTypes.shape({
      firstName: PropTypes.string,
      lastName: PropTypes.string,
    }),
  }),
  onClickEdit: PropTypes.func,
  onClickDelete: PropTypes.func,
  onHandleRead: PropTypes.func,
  isProvider: PropTypes.bool,
};
export default NoteCard;