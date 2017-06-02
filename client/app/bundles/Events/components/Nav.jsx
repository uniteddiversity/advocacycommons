import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';

import NavItem from './NavItem';
import { membersPath, eventsPath, affiliatesPath } from '../utils/Pathnames';

class Nav extends Component {
  renderGroupsTab() {
    const { activeTab } = this.props;

    if (this.isNationalOrgnizer())
      return <NavItem
        title='Groups'
        path={affiliatesPath()}
        active={activeTab === 'groups'}
      />
  }

  isNationalOrgnizer() {
    return this.props.currentRole == 'national_organizer';
  }

  render() {
    const { activeTab } = this.props;

    return (
      <div>
        <ul className="nav nav-tabs">
          {this.renderGroupsTab()}

          <NavItem
            title={`${this.isNationalOrgnizer() ? 'All' : ''} Members`}
            path={membersPath()}
            active={activeTab === 'members'}
          />

          <NavItem
            title={`${this.isNationalOrgnizer() ? 'All' : ''} Events`}
            path={eventsPath()}
            active={activeTab === 'events'}
          />
        </ul>
        <br />
      </div>
    );
  }
}

const mapStateToProps = ({ currentRole }) => {
  return { currentRole }
};

export default connect(mapStateToProps)(Nav);
